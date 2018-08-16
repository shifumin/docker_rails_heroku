# Docker Rails Heroku
Template for building Rails application environment with Docker on Heroku.  
Includes automatic test (RSpec) execution and deployment environment using CircleCI.

## Stack
- Rails 5.2.1 (+ Ruby 2.5.1)
- PostgreSQL 10.5

## Readying

```shell
$ docker pull ruby:2.5.1
$ docker pull postgres:10.5
```

```shell
$ git clone https://github.com/shifumin/docker_rails_heroku
$ cd docker_rails_heroku
```

## Examples of Docker commands

```shell
# rails new
# For installing RSpec later, add '--skip-test' option.
$ docker-compose run --rm web rails new . --database=postgresql --skip-bundle --skip-test

# After `rails new`, you need to replace 'config/database.yml'
$ cp database.yml.sample config/database.yml

# Add 'rspec-rails' gem to Gemfile and run 'bundle install'
$ vim Gemfile
$ docker-compose run --rm web bundle install

# Install RSpec
$ docker-compose run --rm web rails g rspec:install

# rails g
# the following is examples
$ docker-compose run --rm web rails g controller welcome index
$ docker-compose run --rm web rails g model user name:string

# rake db
$ docker-compose run --rm web rails db:create db:migrate

# rspec
$ docker-compose run --rm web rspec

# create and start containers
# boot the app (= `rails s`)
$ docker-compose up

# stop and remove containers
$ docker-compose down

# build or rebuild services
# (e.g.: after changing Gemfile or Dockerfile)
$ docker-compose build  # or `docker-compose up --build`
```

## Deploy to Heroku
First, add the following environment variables to the build on CircleCI application.  
And, register the GitHub repository on the CircleCI application.

### CircleCI Environment Variables

```shell
HEROKU_AUTH_TOKEN=`heroku auth:token`
HEROKU_LOGIN='your_mail@address.com'
HEROKU_API_KEY=`heroku auth:token`
HEROKU_APP_NAME='your_herokuapp_name'
```

Second, add the following environment valiables for Heroku on console.

### Heroku Environment Variables

```shell
$ heroku config:add RACK_ENV=production
$ heroku config:add RAILS_SERVE_STATIC_FILES=enabled
$ heroku config:add RAILS_LOG_TO_STDOUT=enabled
# heroku config:add LANG=en_US.UTF-8
$ heroku config:add SECRET_KEY_BASE=$(docker-compose run --rm web rails secret)
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
