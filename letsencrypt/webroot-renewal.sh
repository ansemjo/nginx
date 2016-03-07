#!/bin/bash
# from: https://gist.githubusercontent.com/thisismitch/e1b603165523df66d5cc/

echo -e "\n[ DATE ] $(date)"

web_service='nginx.service'
config_file="/etc/nginx/letsencrypt.conf"

le_path='/opt/letsencrypt'
exp_limit=30;

if [ ! -f $config_file ]; then
        echo "[ERROR] config file does not exist: $config_file"
        exit 1;
fi
echo "[CONFIG] $config_file"

domain=$(grep "^\s*domains" $config_file | sed "s/^\s*domains\s*=\s*//" | sed 's/[[:space:]].*$\|,.*$//')
echo "[DOMAIN] $domain"
cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"

if [ ! -f $cert_file ]; then
	echo "[ERROR] certificate file not found for domain $domain."
fi

exp=$(date -d "$(openssl x509 -in $cert_file -text -noout | grep "Not After" | cut -c 25-)" +%s)
datenow=$(date -d "now" +%s)
days_exp=$(echo \( $exp - $datenow \) / 86400 |bc)

echo "[VERIFY] Checking expiration date for $domain..."

renew() {
    $le_path/letsencrypt-auto certonly -a webroot --agree-tos --renew-by-default --config $config_file
	echo "[RELOAD] Reloading $web_service"
	/bin/systemctl reload "$web_service"
	echo "[FINISH] Renewal process finished for domain $domain"
}

if [ "$1" = "--force" ] ; then
	echo "[FORCED] Forcing renewal for $domain. Starting webroot renewal script..."
    renew
    exit 0;
elif [ "$days_exp" -gt "$exp_limit" ] ; then
	echo "[  OK  ] The certificate is up to date, no need for renewal ($days_exp days left)."
	exit 0;
else
	echo "[EXPIRE] The certificate for $domain is about to expire soon. Starting webroot renewal script..."
    renew
	exit 0;
fi
