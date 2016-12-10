require 'spec_helper'

describe VlatkoDawanda::Money do

  context '#conversion_rates parsing' do
    let(:hash_currency_input){{'USD' => 1.11, 'Bitcoin' => 0.0047}}
    let(:currencies){described_class.conversion_rates('EUR', hash_currency_input)}

    it 'includes the right currencies from input' do
      expect(currencies.keys).to contain_exactly(:eur, :usd, :bitcoin)
    end

    it 'does not include a currency that is not in the input' do
      expect(currencies.keys).to_not include(:mkd)
    end

    context 'raises an InvalidRate' do
      specify 'rate is zero' do
        invalid_hash = {'MKD' => 0}
        expect{described_class.conversion_rates('EUR', invalid_hash)}.to raise_error VlatkoDawanda::InvalidRate
      end

      specify 'rate is negative number' do
        invalid_hash = {'MKD' => -1}
        expect{described_class.conversion_rates('EUR', invalid_hash)}.to raise_error VlatkoDawanda::InvalidRate
      end
    end

    it 'parses the base currency with rate 1' do
      expect(currencies[:eur][:rate]).to eq 1
    end

    it 'parses the currencies with bigdecimal classes' do
      expect(currencies.map{|k,v| v[:rate]}).to all(be_an_instance_of(BigDecimal))
    end

    it 'equals the same rates as the input hash' do
      expect(currencies[:usd][:rate]).to eq hash_currency_input[currencies[:usd][:iso_code]]
      expect(currencies[:bitcoin][:rate]).to eq hash_currency_input[currencies[:bitcoin][:iso_code]]
    end
  end

  context 'instantation of objects' do
    before(:context) do
      described_class.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end

    let(:existing_currency){described_class.new(50, 'EUR')}
    let(:non_existing_currency){described_class.new(50, 'MKD')}
    let(:float_currency){described_class.new(50.50, 'USD')}

    it 'is valid when existing currency is in input' do
      expect{ existing_currency }.to_not raise_error VlatkoDawanda::UnknownCurrency
    end

    it 'is raises UnknownCurrency error when non existing currency is in input' do
      expect{ non_existing_currency }.to raise_error VlatkoDawanda::UnknownCurrency
    end

    context 'depending of the amount input' do

      it 'outputs the amount in integer when 50' do
        expect(existing_currency.amount).to eq 50
        expect(existing_currency.amount).to be_an(Integer)
      end

      it 'outputs the amount in float when 50.50' do
        expect(float_currency.amount).to eq 50.50
        expect(float_currency.amount).to be_an(Float)
      end

    end

    it 'outputs iso code for currency' do
      expect(existing_currency.currency).to eq 'EUR'
    end

    it 'outputs the amount and currency iso code when inspected' do
      expect(existing_currency.inspect).to eq "50.00 EUR"
    end
  end

  context 'conversion to different currency' do
    before(:context) do
      @currencies = described_class.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end

    let(:euro){described_class.new(50,'EUR')}

    specify 'eur to usd' do
      usd = euro.convert_to('USD')
      expect(usd.amount).to eq(55.5)
      expect(usd.currency).to eq('USD')
    end

    specify 'eur to usd to eur' do
      usd = euro.convert_to('USD')

      expect(usd.convert_to('EUR').amount).to eq(euro.amount)
    end

    specify 'to same currency' do
      expect(euro.convert_to('EUR').amount).to eq(euro.amount)
    end

    it 'raises UnknownCurrency error for non existing rate' do
      expect{ euro.convert_to('MKD') }.to raise_error VlatkoDawanda::UnknownCurrency
    end
  end

end
