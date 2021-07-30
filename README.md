# About

This is a minimalist guide to setting up a docker-compose environment for Rails.
It includes a container ofr PostgreSQL and a container for Redis.
Assuming you have Docker installed, this *should* work out of the box.

# Components

 * Docker
 * Docker-compose 
 * Rails 
 * PostgreSQL 
 * Redis 
 * Heroku 


# Setup Instructions

## 0) Local configuration

Replace all [APPNAME] with an appropriate name.

## 1) Generate rails app

```
  docker-compose run --no-deps web yarn
  docker-compose run --no-deps web rails new . --force --database=postgresql
  docker-compose build
```

## 2) Configure app

```
  database.yml -> config/database.yml
  release -> bin/release
  Uncomment line in Dockerfile
```

## 3) Setup db

```
  docker-compose run web rake db:create
  docker-compose up
```

From this point, a minimal rails server is running with a redis and postgreSQL container.

# Heroku Config

Create a new Heroku app. In the CLI, set the Heroku stack to container (for Docker)-
```
  heroku stack: set container
```

Since Heroku only uses Docker (and not docker-compose), only the Web container will be pushed.
You need to manually add the PG and Redis containers-
```
  heroku addons:create heroku-postgres
  heroku addons:create heroku-redis
```

Finally, deploy your app through your choice of method.
I prefer automatic deployment by linking it to the GitHub repository, but any should work.

# Usage

Running a rails command
```
  docker-compose run web rails ...
  or
  docker-compose run web bash
```
Running the server locally
```
  docker-compose up
```
Using docker-compose in detached mode
```
  docker-compose up -d
  docker-compose down
```

# Debugging

Any time you modify the Gemfile, you need to 
```
  docker-compose build
```

After configuration and connecting, you may find a line like this in log/development.log
```
  Cannot render console from 172.21.0.1! Allowed networks: 127.0.0.0/127.255.255.255, ::1
```

You can allow this by adding something like this to config/development.rb
```
  # Allow connections from localhost
  config.web_console.permissions = '172.21.0.0/16'
```

If Heroku isn't detecting images in your asset pipeline, my working solution is to remove the following line in config/production.rb:
```
  config.assets.compile = false
```


# Resources

Based originally on [this guide](https://docs.docker.com/samples/rails/).