class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    short_urls = ShortUrl.all.order(click_count: :desc).limit(100)

    render json: { urls: short_urls }
  end

  def create
  end

  def show
  end

end
