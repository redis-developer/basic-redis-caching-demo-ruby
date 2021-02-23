# Basic caching demo Ruby

This app returns the number of repositories a Github account has. When you first search for an account, the server calls Github's API to return the response. This can take some time. The server then adds the details of this slow response to Redis for future requests. When you search again, the next response comes directly from Redis cache instead of calling Github. The responses become much faster.

## How to run it locally?

#### Run these commands:

```sh
bundle install
rails db:create
```

#### Copy `config/application.yml.example` to create `config/application.yml`. And provide the values for environment variables

    - REDIS_ENDPOINT_URI: Redis server URI
    - REDIS_PASSWORD: Password to the server
    - FRONTEND_ENDPOINT: Connection with your frontend side
    - HOST: Your host

#### Look `config/application.yml.example` for values examples

#### Run frontend

```sh
cd client
yarn install
npm run serve
```

#### Run backend

```sh
rails s 
```