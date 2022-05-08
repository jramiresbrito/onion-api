# Testing endpoing for checking the API configuration.
class HomeController < ApplicationController
  def index
    render json: { ok: true }
  end
end
