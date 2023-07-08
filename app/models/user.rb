# - id: integer
# - name: string
# - age: integer
# - email: string
class User < ApplicationRecord
  validates :name, presence: true
  validates :age, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true, uniqueness: true
end
