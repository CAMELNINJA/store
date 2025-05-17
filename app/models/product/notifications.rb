module Product::Notifications
  extend ActiveSupport::Concern

  included do
    has_many :subscribers, dependent: :destroy
    after_update_commit :notify_subscribes, if: :back_in_stock?
  end

  def back_in_stock?
    inventory_count_previously_was ==0 && inventory_count >0
  end

  def notify_subscribes
    subscribers.each do |subscriber|
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
    end
  end
end
