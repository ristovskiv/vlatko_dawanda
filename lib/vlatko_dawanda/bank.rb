module VlatkoDawanda
  class Bank

    def conversion_rates(base_currency, currencies)
      @currencies = parse_currencies(base_currency, currencies)
    end

    def currencies
      @currencies ||= {}
    end

    def find_currency(search)
      currency = case search
      when ::String, ::Symbol
        currencies[currency_id(search)]
      when Currency
        found = currencies[currency_id(search.iso_code)]
        raise UnknownCurrency.new('currency not matching the rate') unless found == search
        found
      end

      raise UnknownCurrency.new('currency not found') if currency.nil?
      currency
    end

    private

    def parse_currencies(base_currency, currencies)
      currencies.merge({base_currency => 1}).inject({}) do |memo, (key,value)|
        memo[currency_id(key)] = Currency.new({iso_code: key, rate: value})
        memo
      end
    end

    def currency_id(value)
      value.downcase.to_sym
    end

  end
end
