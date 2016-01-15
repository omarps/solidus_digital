require 'spec_helper'

RSpec.describe Spree::Calculator::Shipping::DigitalDelivery do
  subject { Spree::Calculator::Shipping::DigitalDelivery.new }

  it 'has a description for the class' do
    expect(Spree::Calculator::Shipping::DigitalDelivery).to respond_to(:description)
  end

  context '#compute_package' do
    it 'should ignore the passed in object' do
      expect {
        subject.compute_package(double)
      }.not_to raise_error
    end

    it 'should always return the preferred_amount' do
      amount_double = double
      expect(subject).to receive(:preferred_amount).and_return(amount_double)
      expect(subject.compute_package(double)).to eq(amount_double)
    end
  end

  context '#available?' do
    let(:digital_order) {
      order = create(:order)
      variants = 3.times.map { create(:variant, :digitals => [FactoryGirl.create(:digital)]) }
      package = Spree::Stock::Package.new(create(:stock_location), [])
      variants.each { |v|
        order.contents.add(v, 1)
        order.create_proposed_shipments
        package.add(order.inventory_units.where(variant_id: v.id).first, 1)
      }
      package
    }

    let(:mixed_order) {
      order = create(:order)
      variants = 2.times.map { create(:variant, :digitals => [FactoryGirl.create(:digital)]) }
      variants << create(:variant)
      package = Spree::Stock::Package.new(create(:stock_location), [])
      variants.each { |v|
        order.contents.add(v, 1)
        order.create_proposed_shipments
        package.add(order.inventory_units.where(variant_id: v.id).first, 1)
      }
      package
    }

    let(:non_digital_order) {
      order = create(:order)
      variants = 3.times.map { create(:variant) }
      package = Spree::Stock::Package.new(create(:stock_location), [])
      variants.each { |v|
        order.contents.add(v, 1)
        order.create_proposed_shipments
        package.add(order.inventory_units.where(variant_id: v.id).first, 1)
      }
      package
    }

    it 'should return true for a digital order' do
      expect(subject.available?(digital_order)).to be true
    end

    it 'should return false for a mixed order' do
      expect(subject.available?(mixed_order)).to be false
    end

    it 'should return false for an exclusively non-digital order' do
      expect(subject.available?(non_digital_order)).to be false
    end
  end
end
