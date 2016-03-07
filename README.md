# nginx configuration

This is the configuration folder for [semjonov.de](https://www.semjonov.de/) and its subdomains. These files would normally be found in `/etc/nginx` in a [LEMP stack](https://lemp.io/) (using [nginx](https://www.nginx.com/resources/wiki/start/topics/examples/full/)).

After trying a few approaches I decided to finally clean up the mess and do as much as possible with includes and symlinks to reduce the amount of redundant configuration.

## folders & files explained

### `conf.d/`
Configuration files that have to be included in the http block. Applies to all servers and subdomains.


### `locations//`
Location blocks that can be used in server blocks. Usually one 'service' per file, with multiple location blocks possible.

_note:_ `php_socket` has no `location { ... }` brackets, it must be included inside of another location block. `php_handler` simply wraps this into a location regex that matches all *.php files - everywhere. This is a simple variant to enable fastcgi when the scripts lie in the appropriate subfolder of the root of the server. Otherwise `php_socket` has to be used in a more precisely matching location, as is the case with phpMyAdmin without an appropriate symlink.

### `locations/enabled/`

Locations to enable per server. Each subdirectory corresponding to the server / subdomain name contains symlinks to the needed files in `locations/`. Those folders shall be included in server blocks.

### `params.d/`
Common parameters, like proxy, ssl or fastcgi settings.

### `virtualhosts/`
Available server and subdomain blocks.
Here, the `default` server catches all http connections on port 80 and redirects to the https version.

### `virtualhosts/enabled/`
Symlinks to files in `virtualhosts` of server and subdomains to enable. This folder is included in `nginx.conf`.

### `letsencrypt.conf`
Settings for auto-renewal of [Let's Encrypt](https://letsencrypt.org/) certificates. For use with 

### `nginx.conf`
Main configuration file, which is loaded by nginx and includes the rest.