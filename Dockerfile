FROM backent/nginx-php-fpm-node:7.3

#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Make sure the port as port on nginx/app.conf file
ARG PORT=9898

COPY ./supervisor/supervisor.conf /etc/supervisor/ 
COPY ./nginx/app.conf /etc/nginx/sites-enabled/
COPY --chown=www-data:www-data ./run/run.sh /usr/src/
RUN chmod 755 /usr/src/run.sh

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# -- Using ssh git repo as application --
# ARG BRANCH
# ARG REPO_URL
# RUN mkdir -m 700 /root/.ssh/

# ADD ./ssh/id_rsa /root/.ssh/id_rsa

# Create known_hosts
# RUN touch /root/.ssh/known_hosts

# Add github key
# RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Add gitlab key
# RUN ssh-keyscan gitlab.com >> /root/.ssh/known_hosts

# RUN git init .
# RUN git remote add origin ${REPO_URL}
# RUN git fetch origin ${BRANCH}
# RUN git checkout ${BRANCH}
# -- End using ssh ---

# -- Copy project from application dir as application --
COPY ./application/data /usr/src/app
# -- END using Copy project --

RUN chown -R www-data:www-data /usr/src/app


# install package composer
RUN composer install --ignore-platform-reqs --no-scripts --no-cache
RUN composer dump-autoload


# Uncomment below if you using laravel passport
# RUN php artisan passport:keys

# Uncomment below if you using npm for the project to install package npm
# RUN npm install

# --- if you have some environtment to include in image
# copy environtment file
# ADD ./environment/.env .env
# --- 

# --- Use this if you need
RUN cp ./.env.example ./.env
RUN php artisan key:generate
# ---

# RUN php artisan migrate
# RUN php artisan passport:install


EXPOSE ${PORT}

CMD ["/usr/src/run.sh"]
