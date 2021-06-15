# Basic Redis caching demo with Ruby

This app returns the number of repositories owned by a given Github account. When you first search for an account, the server calls **Github's API** to return the response. This can take **200-500ms** (local testing results). The server caches the details of this response, using **Redis** for future requests. When you search again, the next response comes directly from the **Redis cache** instead of calling Github. Responses return much more quickly - **0.01ms - 0.035ms**.

![How it works](https://github.com/redis-developer/basic-redis-caching-demo-ruby/raw/master/public/example.png)

# Overview video

Here's a short video that explains the project and how it uses Redis:

[![Watch the video on YouTube](https://github.com/redis-developer/basic-redis-caching-demo-ruby/raw/master/public/YTThumbnail.png)](https://youtube.com/watch?v=Ov18gLo0Da8)

## How it works

### How the data is stored:

`GITHUB_ACCOUNT`s with `NUMBER_OF_REPOSITORIES` are stored in Redis store in string format for particular time (`SECONDS`, default: 3600 seconds). You can set/change it with these commands:

- Set the number of repositories for the account (use the user name for key): `SETEX <account name> <seconds till expire> <number of public repos>`
  - E.g `SETEX microsoft 3600 197`

##### Code example:

```Ruby
cached_repositories = redis.get(@username)

elapsed_time = Benchmark.measure do
  if cached_repositories.present?
    # ...
```

### How the data is accessed:

- Get number of public repositories for an account: `GET <account name>`

  - E.g `GET microsoft`

- You can get the remaining time to live of a key (`SECONDS`) with this command:
  - E.g `TTL microsoft`

##### Code example:

```Ruby
redis.setex(@username, 3600, @repositories)
```

## How do you run this application locally?

### Prerequisites

- Ruby - v2.7.0
- Rails - v5.2.4.5
- NPM - v7.6.0

### Local installation:

#### Configure the application:
```sh
# Rename the example YAML config file
cp config/application.yml.example config/application.yml

# Edit the `application.yml` file to point to your Redis instance:

- REDIS_URL: 'redis://localhost:6379'
```

#### From the application's root directory, install the application's dependencies
```sh
bundle install
```

#### Run the application
```sh
bin/rails s
```

#### Navigate with your browser to this URL (if running on localhost)
```sh
http://localhost:3000
```

## Deploying with Redis Cloud

To deploy the application using Redis Cloud, you'll first need to [create free account](https://redislabs.com/try-free/). Then you can get your cloud Redis URI. You can specify this URI in `config/application.yml`.

### Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

[![Deploy](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run/?git_repo=https://github.com/redis-developer/basic-redis-caching-demo-ruby)
