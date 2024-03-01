class Place < ApplicationRecord
  belongs_to :user
  has_many :experiences, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo

  def average_rating
    ratings.average(:value).to_f
  end
end
