class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |attr|
      define_method("#{attr}") do
        instance_variable_get("@#{attr}")
      end

      define_method("#{attr}=") do |set_name|
        instance_variable_set("@#{attr}", set_name)
      end
    end
  end
end
