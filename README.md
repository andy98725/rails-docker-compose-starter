# About
There currently aren't many clear and concise guides to starting out with docker-compose and Rails.
This aims to suppliment that with a minimal configuration.

# Components
 * Docker (installation required)
 * Docker-compose (used locally, installation required)
 * Rails (Docker container)
 * PostgreSQL (Docker container)
 * Redis (Docker container)
 * Heroku (example hosting w/ config instructions)


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

# Debugging

Any time you modify the Gemfile, you may need to 
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


# Credit
Based initially on [this guide](https://docs.docker.com/samples/rails/).
