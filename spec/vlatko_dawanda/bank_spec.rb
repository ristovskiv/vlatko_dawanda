require 'spec_helper'

describe VlatkoDawanda::Bank do
  it 'has currencies attribute that is a dictionary hash' do
    expect(subject).to respond_to(:currencies)
    expect(subject.currencies).to be_an_instance_of Hash
  end

  context 'conversion rates' do
    before do
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


end