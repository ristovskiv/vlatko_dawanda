require 'spec_helper'

describe VlatkoDawanda::Currency do
  let(:currency){described_class.new({iso_code: 'EUR', rate: rand(0.1..5.0)})}
  let(:invalid_currency){described_class.new({iso_code: 'USD', rate: rand(-5.0..0)})}

  context 'valid' do
    specify 'to have rate' do
      expect(currency).to respond_to(:rate)
    end

    specify 'to have iso_code' do
      expect(currency).to respond_to(:iso_code)
    end

    specify 'when the rate is a positive float or integer' do
      expect{currency}.to_not raise_error(VlatkoDawanda::InvalidRate)
    end

    specify 'rate is BigDecimal' do
      expect(currency.rate).to be_an_instance_of(BigDecimal)
    end
  end

  context 'invalid' do
    specify 'when the rate is not a positive float or integer' do
      expect{invalid_currency}.to raise_error(VlatkoDawanda::InvalidRate)
    end
  end

  context 'comparable' do
    let(:equal_currency){currency.dup}
    it 'should be equal if the rate of the other is equal' do
      expect(currency).to eq equal_currency
    end

    it 'should not equal if the rate of the other is different' do
      diff_currency = described_class.new({iso_code: equal_currency.iso_code, rate: equal_currency.rate + 1 })

      expect(currency).to_not eq diff_currency
    end
  end
end