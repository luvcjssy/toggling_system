class School < ApplicationRecord
  has_many :children, class_name: 'School', foreign_key: :parent_id
  belongs_to :parent, class_name: 'School', foreign_key: :parent_id, optional: true
  belongs_to :owner, class_name: 'User'

  enum payment_type: [:free, :paid]

  scope :hq, -> { where(parent_id: nil ) }
end