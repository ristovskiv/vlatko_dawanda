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

end
