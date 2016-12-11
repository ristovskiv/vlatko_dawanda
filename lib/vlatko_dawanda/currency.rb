module VlatkoDawanda
  class Currency
    include Comparable

    attr_reader :iso_code, :rate

    def initialize(options = {})
      @iso_code = options[:iso_code]
      @rate = validate_rate(options[:rate])
    end

    def <=>(other)
      rate <=> other.rate
    end

    private

    def validate_rate(value)
      rate = value.to_d rescue 0.to_d
      raise InvalidRate.new('please enter a positive float or integer as a rate') if rate <= 0
      rate
    end
  end
end
