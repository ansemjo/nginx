# nginx configuration

This is the configuration folder for an [nginx] webserver. These files would
normally be located in `/etc/nginx`.

It originated as my configuration for semjonov.de and its subdomains. After
trying a few approaches I decided to finally clean up the mess I had produced
and do as much as possible with includes and symlinks to reduce the amount of
redundant configuration.

---

I try to keep the `generic` branch updated at all times to serve as a good
starting point to replace the default config. It is currently optimized for an
installation under Arch Linux, so you might need to adjust some paths.

## some folders & files explained

For general questions concerning various directives, please consult the
excellent [documentation] available.

<br>
* `nginx.conf`
Main configuration file, which is loaded by nginx and includes the rest.
    * Adjust `user`, `root`, log locations and ssl cert settings as needed.

<br>
* `config/*`
Configuration files that are included globally in the http block.
    
    * `errorcodes`:
    mappings of some error codes to their names & descriptions; for use with the
    `errorpages` location
    
    * `compression`, `fastcgi`, `proxy`, `ssl`:
    various global settings and parameters
    
    * `fastcgi`:
    there is a map in this file, which maps php-fpm sockets to server_names;
    adjust as needed
    
    * `proxy`:
    this file defines a proxy cache zone; use with `proxy_cache PROXY;`

<br>
* `locations/*`
Location blocks that can be used in server blocks. Usually, there is one
'service' per file.

    * `locations/enabled/<server_name>/*`
    Locations to enable per server. Each subdirectory corresponding to the
    server / subdomain name contains symlinks to the needed files in
    `locations/` (or `../../` relative). Those folders shall be included in
    server blocks. Enables behaviour similar to Apache's `sites-enabled`.

    * `acme-challenge`:
    For use with the Let's Encrypt webroot plugin. Serves all requests for files
    under `.well-known/acme-challenge/` in one folder.
    
    * `errorpages`:
    sort of a server-wide replacement of the error pages; requires / uses values
    set in `errorcodes` above; available as a [gist] on GitHub
    
    * the rest are examples of proxied node applications or applications served
    with php-fpm ([Etherpad-Lite], [Ghost], [GitLab], [phpMyAdmin], [Owncloud])

<br>
* `vhosts/*`
Server and subdomain blocks. For each (sub)domain there should be one file here.

    * `vhosts/enabled/`
    symlinks to vhosts which shall be enabled; this folder is included in
    `nginx.conf`
    
    * `default_server`:
    configuration-less default server, that catches all request which do not
    match any other server block and redirects the to the configured hostname of
    the machine

<br>
* `snippets/*`
Short snippets not otherwise categorized and intended for inclusion in other
files.

    * `deny.*`
    deny access to a certain feature, e.g. serve restrictive robots.txt
    
    * `fastcgi.sock`:
    wrapper of the `fastcgi_pass` directive, which uses the variable set by the
    map in `config/fastcgi`
    
    * `redirection.*`:
    well, redirections .. e.g. to https version if not already served via https
    
    * `secureheaders.*`:
    add sensible or empty headers for HSTS, X-Content-Type, X-Frame and X-XSS or
    hide proxied headers to set your own .. (sometimes you end up with duplicate
    values in these header fileds, applications complain and settings are not
    properly followed)
    
    * `sslcert.*`:
    simply snippets defining the locations of cert and key for ssl connections;
    you might want or need to regenerate selfsigned (snakeoil) certs for testing
    purposes - a simple one-liner is inside the file:
    `# openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem`


[nginx]: https://www.nginx.com/ "NGINX Homepage"
[documentation]: http://nginx.org/en/docs/ "nginx documentation"
[gist]: https://gist.github.com/ansemjo/1732677804dfd2cf962565279096252b
[Etherpad-Lite]: http://etherpad.org/
[Ghost]: https://ghost.org/
[GitLab]: https://gitlab.com
[phpMyAdmin]: https://www.phpmyadmin.net/
[Owncloud]: https://owncloud.org/