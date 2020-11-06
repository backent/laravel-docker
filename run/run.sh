#!/bin/bash
# uncomment this if you using ssh to run the project on container
# git pull

composer install --ignore-platform-reqs --no-scripts
composer dump-autoload

# uncomment this if you using laravel passport
# php artisan passport:keys

php artisan migrate

/usr/bin/supervisord -n -c /etc/supervisor/supervisor.conf

