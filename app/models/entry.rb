class Entry < ActiveRecord::Base
  attr_accessible :entry_logo, :github_url, :live_demo_url, :name, :description, :member_id, :team_members
  belongs_to :member
  belongs_to :challenge
  validates :name, :description, :github_url, presence: true
  mount_uploader :entry_logo, EntryLogoUploader

  def self.public
    where public: true
  end

  def publish!
    self.public = true
  end
end
