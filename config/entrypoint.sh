#!/bin/sh

php /var/www/html/artisan config:cache
php /var/www/html/artisan route:cache

# Hand off to the CMD
exec "$@"