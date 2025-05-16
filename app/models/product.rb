class Product < ApplicationRecord
  has_many :subscribers, dependent: :destroy
  has_one_attached :featured_image
  has_rich_text :description

  validates :name, presence: true
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }

  def back_in_stock?
    inventory_count_previously_was.zero? && inventory_count > 0
  end

  def notify_subscribes
     subscribers.each do |subscriber|
       ProductMailer.with(product: self, subscriber: subscriber).in_stock.delivery_later
     end
  end
end
