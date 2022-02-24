#!/bin/sh

php /var/www/init.php
php /var/www/html/artisan config:cache
php /var/www/html/artisan route:cache

# Hand off to the CMD
exec "$@"