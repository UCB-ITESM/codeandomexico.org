class Brigade < ActiveRecord::Base
  belongs_to :user
  attr_accessible :calendar_url, :city, :description, :facebook_url, :github_url, :header_image_url, :slack_url, :state,
                  :twitter_url, :user, :zip_code
end
