Spree::Order.class_eval do
  register_update_hook :generate_digital_links

  # removing address state if all items are digital
  checkout_flow do
    go_to_state :address, if: ->(order) {!order.digital?}
    go_to_state :delivery, if: ->(order) {!order.digital?}
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm
  end


  # before_transition to: :payment, do: :set_digital_shipment

  def set_digital_shipment
    debugger
    if self.digital?
      puts 'yes'
    end
  end

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
    if self.complete?
      self.line_items.each{|a|a.create_digital_links} 
    end
  end

end
