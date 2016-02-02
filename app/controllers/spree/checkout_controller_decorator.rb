Spree::CheckoutController.class_eval do
  orig_edit = instance_method(:edit)
  orig_update = instance_method(:update)

  define_method(:edit) do
    if @order.digital?
      puts 'order is digital'
      render :edit
    end
    orig_edit.bind(self).()
  end

  define_method(:update) do
    if @order.digital?
      ship_address = Spree::Address.find_or_create_by!(
          {
              firstname: 'solidus_digital',
              lastname: 'solidus_digital',
              address1: 'solidut_digital',
              city: 'solidut_digital',
              phone: 'solidut_digital',
              state_id: Spree::Country.find(Spree::Config.default_country_id).states.first.id,
              country_id:Spree::Config.default_country_id

          })
      @order.ship_address = ship_address
    end
    orig_update.bind(self).()
  end

end

