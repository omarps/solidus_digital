Spree::Variant.class_eval do
  has_many :digitals
  after_save :destroy_digitals, if: :deleted?
  
  # has digital option_type as true
  def has_digital_option?
    self.option_values.detect{|a|
      a.option_type.name.eql?('digital') && a.name.eql?('true')
    }
  end

  # if it is a digital variant should have digital attachment
  def is_complete?
    self.has_digital_option? ? self.digital? : true    
  end

  # has digital option_type as true and has digital attachments
  def digital?
    (self.has_digital_option? && self.digitals.present?) ? true : false
  end

  def track_inventory
    self.digital? ? false : super
  end
  
  private
  # :dependent => :destroy needs to be handled manually
  # spree does not delete variants, just marks them as deleted?
  # optionally keep digitals around for customers who require continued access to their purchases
  def destroy_digital
    digitals.map &:destroy unless Spree::DigitalConfiguration[:keep_digitals]
  end

end
