require 'spec_helper'

RSpec.describe Spree::DigitalLink do

  context 'validation' do
    it { is_expected.to belong_to(:digital) }
    it { is_expected.to belong_to(:line_item) }
  end

  context "#create" do
    it "should create an appropriately long secret" do
      expect(create(:digital_link, secret: nil).secret.length).to eq(30)
    end

    it "should zero out the access counter on creation" do
      expect(create(:digital_link, access_counter: nil).access_counter).to eq(0)
    end
  end

  context "#update" do
    it "should not change the secret when updated" do
      digital_link = create(:digital_link)
      secret = digital_link.secret
      digital_link.increment(:access_counter).save
      expect(digital_link.secret).to eq(secret)
    end

    it "should enforce to have an associated digital" do
      link = create(:digital_link)
      expect { link.update_attributes!(:digital => nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow an empty or too short secret" do
      link = create(:digital_link)
      expect { link.update_attributes!(:secret => nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { link.update_attributes!(:secret => 'x' * 25) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "authorization" do
    it "should increment the counter using #download!" do
      link = create(:digital_link)
      expect(link.access_counter).to eq(0)
      expect {
        link.download!
      }.to change(link, :access_counter).by(1)
    end

   it "should not be #authorized? when the access_counter is too high" do
     link = create(:digital_link)
     allow(link).to receive_messages(:access_counter => Spree::DigitalConfiguration[:authorized_clicks] - 1)
     expect(link.downloadable?).to be true
     allow(link).to receive_messages(:access_counter => Spree::DigitalConfiguration[:authorized_clicks])
     expect(link.downloadable?).to be false
   end

   it "should not be #download! when the created_at date is too far in the past" do
     link = create(:digital_link)
     expect(link.download!).to be true
     allow(link).to receive_messages(:created_at => (Spree::DigitalConfiguration[:authorized_days] * 24 - 1).hours.ago)
     expect(link.download!).to be true
     allow(link).to receive_messages(:created_at => (Spree::DigitalConfiguration[:authorized_days] * 24 + 1).hours.ago)
     expect(link.download!).to be false
   end

   it "should not be #authorized? when both access_counter and created_at are invalid" do
     link = create(:digital_link)
     expect(link.downloadable?).to be true
     allow(link).to receive_messages(:access_counter => Spree::DigitalConfiguration[:authorized_clicks], :created_at => (Spree::DigitalConfiguration[:authorized_days] * 24 + 1).hours.ago)
     expect(link.downloadable?).to be false
   end

  end

  context '#reset!' do
    it 'should reset the access counter' do
      link = create(:digital_link)
      link.download!
      expect(link.access_counter).to eq(1)
      link.reset!
      expect(link.access_counter).to eq(0)
    end
  end
end

