#!/usr/bin/env bash

set -e

reset="\033[0m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
cyan="\033[36m"
white="\033[37m"

echo -e "${PWD}/.env"

if [[ ! -e "${PWD}/.env" ]]; then
    if [[ -z "$1" ]]; then
        read -p "Please enter the PackageKit project cdn key. Follow the link and create a project: https://www.pkgkit.com/awes-io/create
" -e KEY
    else
        KEY=$1
    fi

    if [[ -z "$2" ]]; then
        read -p "Please enter the PackageKit project token.
" -e TOKEN
    else
        TOKEN=$2
    fi
fi

printf "$green> Check chmod for storage dirrectory$reset\n"
chmod -R 777 ./storage

printf "$green> Check bootstrap for storage dirrectory$reset\n"
chmod -R 777 ./bootstrap

printf "$green> Shutdown all current docker demo containers$reset\n"
docker-compose down -v

printf "$green> Docker compose up$reset\n"
docker-compose up -d --build

printf "$green> Remove composer.lock file for getting a new updates$reset\n"
rm -f ./composer.lock

if [[ ! -e "${PWD}/.env" ]]; then
    printf "$green> Create .ENV file from local example$reset\n"
    cp .env.docker .env

    printf "$green> Writing PackageKit api token and cdn key$reset\n"
    docker exec -i awes-demo-php bash -c "composer global require awes-io/installer"
    docker exec -i awes-demo-php bash -c "php ~/.composer/vendor/bin/awes-io token -t $TOKEN"
    docker exec -i awes-demo-php bash -c "php ~/.composer/vendor/bin/awes-io key -k $KEY"
fi

printf "$green> Install all dependencies$reset\n"
docker exec -i awes-demo-php bash -c "composer install"

printf "$green> Service commands for Laravel: migration, key generate, cache clear etc $reset\n"
docker exec -i awes-demo-php sh -c "php artisan key:generate && php artisan migrate:fresh --seed && php artisan cache:clear"
