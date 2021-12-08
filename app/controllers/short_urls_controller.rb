class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    short_urls = ShortUrl.all.order(click_count: :desc).limit(100)

    render json: { urls: short_urls }
  end

  def create
    short_url = ShortUrl.new(short_url_params.except(:id))

    if short_url.save
      UpdateTitleJob.perform_later(short_url.id)
      render json: { short_code: short_url.short_code }, status: :created
    else
      render json: { errors: short_url.errors.full_messages }
    end
  end

  def show
  end

  private

  def short_url_params
    params.permit(:id, :full_url)
  end
end
