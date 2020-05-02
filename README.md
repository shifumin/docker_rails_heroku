# Docker Rails Heroku
Template for building Rails application environment with Docker on Heroku.  
Includes automatic test (RSpec) execution and deployment environment using CircleCI.

## Stack
- Rails 6.0.2 (+ Ruby 2.7.1)
- PostgreSQL 12.2

## Readying

```shell
$ docker pull ruby:2.7.1-alpine
$ docker pull postgres:12.2-apline
```

```shell
$ git clone https://github.com/shifumin/docker_rails_heroku
$ cd docker_rails_heroku
```

## Examples of Docker commands

```shell
# rails new
# Since .gitignore has been prepared in advance, add '--skip-git' option.
# For installing RSpec later, add '--skip-test' option.
$ docker-compose run --rm app rails new . --database=postgresql --skip-git --skip-test --skip-bundle

# After `rails new`, you need to replace 'config/database.yml'
$ cp database.yml.sample config/database.yml

# Add 'rspec-rails' gem to Gemfile and run 'bundle install'
$ vim Gemfile
$ docker-compose run --rm app bundle install

# Install RSpec
$ docker-compose run --rm app rails g rspec:install

# rails g
# the following is examples
$ docker-compose run --rm app rails g controller welcome index
$ docker-compose run --rm app rails g model user name:string

# rake db
$ docker-compose run --rm app rails db:create db:migrate

# rspec
$ docker-compose run --rm app rspec

# create and start containers
# boot the app (= `rails s`)
$ docker-compose up
# or docker-compose run --rm --service-ports app

# stop and remove containers
$ docker-compose down

# build or rebuild services
# (e.g.: after changing Gemfile or Dockerfile)
$ docker-compose build  # or `docker-compose up --build`
```

## Deploy to Heroku
First, add the following environment variables to the build on CircleCI application.  
And, register the GitHub repository on the CircleCI application.

```shell
# Put Dockerfile in app root to use Dockerfile with Heroku deploy
$ cp -i docker/web/Dockerfile .
```

### CircleCI Environment Variables

```shell
HEROKU_AUTH_TOKEN=`heroku authorizations:create`
HEROKU_LOGIN='your_mail@address.com'
HEROKU_API_KEY=`heroku authorizations:create`
HEROKU_APP_NAME='your_herokuapp_name'
# for development environment
HEROKU_APP_NAME_DEV='your_herokuapp_name_for_development'
```

Second, add the following environment valiables for Heroku on console.

### Heroku Environment Variables

```shell
$ heroku config:add RACK_ENV=production
$ heroku config:add RAILS_SERVE_STATIC_FILES=enabled
$ heroku config:add RAILS_LOG_TO_STDOUT=enabled
# heroku config:add LANG=en_US.UTF-8
$ heroku config:add SECRET_KEY_BASE=$(docker-compose run --rm app rails secret)
```

Next, set up Heroku settings.

### Heroku settings

```
# Install container plugin
$ heroku plugins:install heroku-container-registry

$ heroku container:login
$ heroku create
$ heroku container:push web

# attach postgresql addon
$ heroku addons:create heroku-postgresql:hobby-dev

$ heroku run rails db:migrate
```

### Deploy to Heroku by CircleCI
After completing the above settings, execute deployment.  
When `git push origin master` , CircleCI executes RSpec test and deploys docker container to heroku container registroy.

```
$ git push origin master

# Confirm application on browser.
$ heroku open
```
