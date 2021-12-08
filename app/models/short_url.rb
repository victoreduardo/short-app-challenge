class ShortUrl < ApplicationRecord
  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, presence: true, uniqueness: true
  validates :click_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :short_code, presence: true, uniqueness: true, length: { maximum: 255 }

  validate :validate_full_url

  before_validation :generate_short_code, on: :create

  def generate_short_code
    self.short_code = SecureRandom.uuid[0..5] if full_url.present?
  end

  def update_title!
    require 'open-uri'

    title = open(full_url).read.scan(/<title>(.*?)<\/title>/)
    update(title: title.flatten.first)
  end

  private

  def validate_full_url
    uri = URI.parse(full_url)

    if !uri.is_a?(URI::HTTP) || uri.host.nil?
      errors.add(:full_url, 'is not a valid url')
    end
  rescue URI::InvalidURIError
    errors.add(:full_url, 'is not a valid url')
  end
end
