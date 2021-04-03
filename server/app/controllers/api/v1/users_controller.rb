require 'benchmark'
require 'net/https'
require 'redis'

class Api::V1::UsersController < ApplicationController
  def show
    redis = Redis.new(url: ENV['REDIS_URL'])
    @username = params[:username]
    cached_repositories = redis.get(@username)

    elapsed_time = Benchmark.measure do
      if cached_repositories.present?
        @repositories = cached_repositories.to_i
        @cached = true
      else
        url = "https://api.github.com/users/#{@username}"
        response = Net::HTTP.get_response(URI.parse(url))
        data = JSON.parse(response.body)
        @repositories = data['public_repos']
        @cached = false
      end
    end

    if @repositories.is_a?(Numeric)
      redis.setex(@username, 3600, @repositories)

      render json: { username: @username, repositories: @repositories, cached: @cached, time: elapsed_time.real }
    else
      render json: { status: 'error', code: 404 }
    end
  end
end
