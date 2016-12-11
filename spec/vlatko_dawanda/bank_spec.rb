require 'spec_helper'

describe VlatkoDawanda::Bank do
  it 'has currencies attribute that is a dictionary hash' do
    expect(subject).to respond_to(:currencies)
    expect(subject.currencies).to be_an_instance_of Hash
  end

  context 'conversion rates' do
    before(:example) do
      subject.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end

    it 'parses all the currencies values into Currency objects' do
      expect(subject.currencies.values).to all(be_an_instance_of(VlatkoDawanda::Currency))
    end

    it 'parses all the currencies keys to symbols of downcased iso codes' do
      expect(subject.currencies.keys).to contain_exactly(:eur,:usd,:bitcoin)
    end

    it 'parses the base currency with rate 1' do
      expect(subject.currencies[:eur].rate).to eq 1
    end
  end

  context 'find currency' do
    before(:example) do
      subject.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end

    let(:currency_by_iso_code){subject.find_currency('Bitcoin')}

    context 'by iso code' do
      it 'returns the approriate Currency object if the iso code is registered' do
        expect(currency_by_iso_code).to be_an_instance_of(VlatkoDawanda::Currency)
        expect(currency_by_iso_code.iso_code).to eq 'Bitcoin'
        expect(currency_by_iso_code.rate).to eq 0.0047
      end

      it 'raises an error when currency is not found' do
        expect{subject.find_currency('MKD')}.to raise_error VlatkoDawanda::UnknownCurrency
      end
    end

    context 'by currency object' do
      let(:currency_by_object){subject.find_currency(currency_by_iso_code)}

      it 'returns the approriate Currency object if the iso code is registered' do
        expect(currency_by_object).to be_an_instance_of(VlatkoDawanda::Currency)
        expect(currency_by_object.iso_code).to eq 'Bitcoin'
        expect(currency_by_object.rate).to eq 0.0047
      end

      it 'raises an error when currency is not found' do
        invalid_currency = currency_by_object.instance_variable_set('@rate', currency_by_object.rate + 1)
        expect{subject.find_currency(invalid_currency)}.to raise_error VlatkoDawanda::UnknownCurrency
      end
    end
  end


end