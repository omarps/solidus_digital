Spree::Order.class_eval do
  # register_update_hook :generate_digital_links

  # removing address state if all items are digital
  # checkout_flow do
    # go_to_state :address, if: ->(order) {!order.digital?}
    # go_to_state :delivery, if: ->(order) {!order.digital?}
    # go_to_state :address
    # go_to_state :delivery
    # go_to_state :confirm, if: ->(order) {true}
    # go_to_state :payment, if: ->(order) { order.payment_required? }
  #
  # end
  # if 1==1
  #   remove_checkout_step :delivery
  # end
  # accepts_nested_attributes_for :bill_address, :reject_if => :digital?
  state_machine.after_transition :to => :complete, :do => :generate_digital_links

  # before_transition to: :payment, do: :set_digital_shipment

  # def set_digital_shipment
  #   # debugger
  #   if self.digital?
  #     puts 'yes'
  #   end
  # end

  # all products are digital
  def digital?
    line_items.all? { |item| item.digital? }
  end
  
  def some_digital?
    line_items.any? { |item| item.digital? }
  end

  def some_not_digital?
    line_items.any? { |item| !item.digital? }
  end

  alias :has_digital_line_items? :some_digital?
  alias :has_paper_line_items? :some_not_digital?
  
  def digital_line_items
    line_items.select(&:digital?)
  end

  def digital_links
    digital_line_items.map(&:digital_links).flatten
  end

  def reset_digital_links!
    digital_links.each do |digital_link|
      digital_link.reset!
    end
  end

  def generate_digital_links
    # if self.complete?
      self.line_items.each do |a|
        a.create_digital_links if a.digital?
      end
    # end
  end

end
