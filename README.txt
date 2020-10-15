This is a "simplified" nginx configuration directory. It uses a vhosts
structure similar to apache. Every file that matches vhosts/*.conf is
included by the main nginx.conf. It also contains a number of good
security settings, like a relatively strict and modern cipher set and
only TLSv1.2+.

After messing with different branches per server for a long time, I merged
the entire configuration into one generic hierarchy and told git to ignore
new files in vhosts/. So, your specific server configuration is not tracked
and therefore not backed up in git.

Example server blocks can be found in vhosts/example.conf. This file is not
included by nginx, don't worry, no need to delete it.
