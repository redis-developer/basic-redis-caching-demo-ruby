require 'net/https'

class Api::V1::UsersController < ApplicationController
  def show
    get_repositories
  end

  def get_repositories
    username = params[:username]

    start_time = Time.now

    url = "https://api.github.com/users/#{username}"
    response = Net::HTTP.get_response(URI.parse(url))
    data = JSON.parse(response.body)
    repositories = data['public_repos']

    elapsed_time = Time.now - start_time

    if repositories.is_a?(Numeric)
      render json: { username: username, repositories: repositories, cached: false, time: elapsed_time }
    else
      render json: { status: 'error', code: 404 }
    end
  end
end
