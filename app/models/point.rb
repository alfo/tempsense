class Point < ApplicationRecord

  validates :data, presence: true, inclusion: -20..60

end
