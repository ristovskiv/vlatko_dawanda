module VlatkoDawanda
  class Money

    class << self
      attr_reader :currencies

      def conversion_rates(base_currency, currencies)
        @currencies = parse_currencies(base_currency, currencies)
      end

      private

      def parse_currencies(base_currency, currencies)
        currencies.merge({base_currency => 1}).inject({}) do |memo, (key,value)|
          memo[key.downcase.to_sym] = {iso_code: key, rate: value.to_d}
          memo
        end
      end

    end

  end
end
