require 'spec_helper'

describe VlatkoDawanda::Money do
  context 'perform arithmetic operations' do
    before(:context) do
      described_class.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
    end
    let(:fifty_eur){described_class.new(50,'EUR')}
    let(:twenty_usd){described_class.new(20,'USD')}

    it 'raises an error if the other participant is not a number or from Money class' do
      expect{fifty_eur + 'a'}.to raise_error VlatkoDawanda::InvalidOperand
      expect{fifty_eur - 'a'}.to raise_error VlatkoDawanda::InvalidOperand
      expect{fifty_eur * 'a'}.to raise_error VlatkoDawanda::InvalidOperand
      expect{fifty_eur / 'a'}.to raise_error VlatkoDawanda::InvalidOperand
    end

    it 'returns a new Money object' do
      arithemtic_results = ['+','-','*','/'].map{|sign| fifty_eur.send(sign, twenty_usd)}
      expect(arithemtic_results).to all(be_an_instance_of(described_class))
    end

    context '+' do
      specify 'with number' do
        sum = twenty_usd + 2
        expect(sum.inspect).to eq '22.00 USD'
      end

      specify 'with other Money object' do
        sum = fifty_eur + twenty_usd
        expect(sum.inspect).to eq '68.02 EUR'
      end
    end

    context '-' do
      specify 'with number' do
        difference = twenty_usd - 2
        expect(difference.inspect).to eq '18.00 USD'
      end

      specify 'with other Money object' do
        difference = fifty_eur - twenty_usd
        expect(difference.inspect).to eq '31.98 EUR'
      end
    end

    context '*' do
      specify 'with number' do
        product = twenty_usd * 3
        expect(product.inspect).to eq '60.00 USD'
      end

      specify 'with other Money object' do
        product = twenty_usd * fifty_eur
        expect(product.inspect).to eq '1110.00 USD'
      end
    end

    context '/' do
      specify 'with number' do
        quotient = fifty_eur / 2
        expect(quotient.inspect).to eq '25.00 EUR'
      end

      specify 'with other Money object' do
        quotient = fifty_eur / twenty_usd
        expect(quotient.inspect).to eq '2.78 EUR'
      end
    end
  end
end
