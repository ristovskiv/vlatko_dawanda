require 'spec_helper'

describe VlatkoDawanda::Money do
  context 'bank' do
    it 'is configurable for all money objects' do
      expect(described_class).to respond_to(:bank=)
      expect(described_class).to respond_to(:bank)
    end

    specify 'its default bank to be the Bank class' do
      expect(described_class.bank).to be_an_instance_of(VlatkoDawanda::Bank)
    end
  end

  context 'instantiate an object' do
    before(:context) do
      described_class.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end

    context 'validation' do
      specify 'when the currency is registered' do
        euro = described_class.new(50, 'USD')
        expect{euro}.to_not raise_error VlatkoDawanda::UnknownCurrency
        expect(euro.instance_variable_get('@currency')).to be_an_instance_of(VlatkoDawanda::Currency)
      end

      it 'raises UnknownCurrency error when the currency is not registered' do
        expect{described_class.new(50, 'MKD')}.to raise_error VlatkoDawanda::UnknownCurrency
      end
    end

    context 'parsed outputs for attributes' do
      let(:existing_currency){described_class.new(50, 'EUR')}
      let(:float_currency){described_class.new(50.50, 'USD')}

      it 'outputs the amount in integer when integer input' do
        expect(existing_currency.amount).to eq 50
        expect(existing_currency.amount).to be_an(Integer)
      end

      it 'outputs the amount in float when float input' do
        expect(float_currency.amount).to eq 50.50
        expect(float_currency.amount).to be_an(Float)
      end

      it 'outputs iso code for currency' do
        expect(existing_currency.currency).to eq 'EUR'
      end

      it 'outputs the amount and currency iso code when inspected' do
        expect(existing_currency.inspect).to eq "50.00 EUR"
      end
    end
  end

  context 'conversion to different currency' do
    before(:context) do
      described_class.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
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

  context 'comparisons' do
    before(:context) do
      described_class.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end

    let(:fifty_eur){described_class.new(50,'EUR')}
    let(:twenty_usd){described_class.new(20,'USD')}

    it "is equal when the other's currency is same and amount" do
      expect(twenty_usd).to eq described_class.new(20,'USD')
    end

    it "is not equal when the other's currency is same but not amount" do
      expect(twenty_usd).to_not eq described_class.new(30,'USD')
    end

    it "is equal when the other's currency is different but the converted amount is the same" do
      fifty_eur_in_usd = fifty_eur.convert_to('USD')
      expect(fifty_eur).to eq fifty_eur_in_usd
    end

    it "is greater when the other's currency is the same but amount is lower" do
      expect(fifty_eur).to be > described_class.new(40,'EUR')
    end

    it "is lower when the other's currency is different but the converted amount is greater" do
      expect(twenty_usd).to be < fifty_eur
    end
  end
end
