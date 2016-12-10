module VlatkoDawanda
  module Arithmetic

    ['+','-','*','/'].each do |method_name|
      define_method(method_name) do |other|
        result = case other
        when ::Numeric
          self.amount.to_d.send(method_name, other.to_d)
        when self.class
          self.amount.to_d.send(method_name, other.convert_to(currency).amount.to_d)
        else
          raise InvalidOperand.new('please enter a number or an object from the Money class')
        end

        self.class.new(result, currency)
      end
    end

    def coerce(other)
      return self, other
    end
  end
end