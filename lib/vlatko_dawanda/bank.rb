module VlatkoDawanda
  class Bank

    def conversion_rates(base_currency, currencies)
      @currencies = parse_currencies(base_currency, currencies)
    end

    def currencies
      @currencies ||= {}
    end

    private

    def parse_currencies(base_currency, currencies)
      currencies.merge({base_currency => 1}).inject({}) do |memo, (key,value)|
        memo[key.downcase.to_sym] = Currency.new({iso_code: key, rate: value})
        memo
      end
    end

  end
end