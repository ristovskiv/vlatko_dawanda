module VlatkoDawanda
  class Money

    include Arithmetic
    include Comparable

    class << self
      attr_writer :bank

      def bank
        @bank ||= Bank.new
      end

      def conversion_rates(base_currency, currencies)
        bank.conversion_rates(base_currency, currencies)
      end
    end

    def initialize(amount, iso_code)
      @amount = amount.to_d
      @currency = bank.find_currency(iso_code)
    end

    def amount
      to_f_or_i(@amount)
    end

    def currency
      @currency.iso_code
    end

    def inspect
      "#{"%.2f" % amount} #{currency}"
    end

    def convert_to(currency)
      to_currency = bank.find_currency(currency)
      amount = if @currency == to_currency
        @amount
      else
        (@amount / @currency.rate) * to_currency.rate
      end
      self.class.new(amount, to_currency.iso_code)
    end

    def <=>(other)
      if currency == other.currency
        amount.to_d.round(2) <=> other.amount.to_d.round(2)
      else
        amount.to_d.round(2) <=> other.convert_to(currency).amount.to_d.round(2)
      end
    end

    private

    def bank
      self.class.bank
    end

    def to_f_or_i(v)
      ((float = v.to_f) && (float % 1.0 == 0) ? float.to_i : float) rescue v
    end

  end
end