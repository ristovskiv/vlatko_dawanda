module VlatkoDawanda
  class Money

    class << self
      def conversion_rates(base_currency, currencies)
        @currencies = parse_currencies(base_currency, currencies)
      end

      def currencies
        @currencies ||= {}
      end

      private

      # I'm doing this instead of simple merge with the input hash
      # cause I prefer working with symbols as keys whenever possible
      # and the garbage collector is not that polluted
      def parse_currencies(base_currency, currencies)
        currencies.merge({base_currency => 1}).inject({}) do |memo, (key,value)|
          rate = validate_rate(value)
          memo[key.downcase.to_sym] = {iso_code: key, rate: rate}
          memo
        end
      end

      def validate_rate(value)
        rate = value.to_d rescue 0.to_d
        raise InvalidRate.new('please enter a positive float as a rate') if rate <= 0
        rate
      end
    end

    def initialize(amount, iso_code)
      @amount = amount.to_d
      @currency = find_currency(iso_code)
    end

    def amount
      to_f_or_i(@amount)
    end

    def currency
      @currency[:iso_code]
    end

    def inspect
      "#{"%.2f" % amount} #{currency}"
    end

    def convert_to(iso_code)
      amount = (@amount / @currency[:rate]) * find_currency(iso_code)[:rate]
      self.class.new(amount, iso_code)
    end

    ['+','-','*','/'].each do |method_name|
      define_method(method_name) do |other|
        result = case other
        when ::Numeric
          amount.to_d.send(method_name, other.to_d)
        when self.class
          amount.to_d.send(method_name, other.convert_to(currency).amount.to_d)
        else
          raise InvalidOperand.new('please enter a number or an object from the Money class')
        end

        self.class.new(result, currency)
      end
    end

    def coerce(other)
      return self, other
    end

    private

    def find_currency(iso_code)
      currency = self.class.currencies[iso_code.downcase.to_sym]
      raise UnknownCurrency.new('currency not found') if currency.nil?
      currency
    end

    def to_f_or_i(v)
      ((float = v.to_f) && (float % 1.0 == 0) ? float.to_i : float) rescue v
    end

  end
end
