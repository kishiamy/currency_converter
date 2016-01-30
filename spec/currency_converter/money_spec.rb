require "spec_helper"

require_relative "../../lib/currency_converter"

describe CurrencyConverter::Money do

  subject { described_class.new(50, "EUR") }

  before do
    CurrencyConverter::Money.conversion_rates("EUR", {
      "USD" => 1.08
    })
  end

  let(:twenty_euros)       { CurrencyConverter::Money.new(20, "EUR") }
  let(:twenty_dollars)     { CurrencyConverter::Money.new(20, "USD") }
  let(:fifty_euros)        { CurrencyConverter::Money.new(50, "EUR") }
  let(:fifty_two_euros)    { CurrencyConverter::Money.new(52, "EUR") }
  let(:fifty_two_dollars)  { CurrencyConverter::Money.new(52, "USD") }
  let(:fifty_four_dollars) { CurrencyConverter::Money.new(54, "USD") }

  describe "#amount" do
    it "returns amount" do
      expect(subject.amount).to eql 50
    end
  end

  describe "#currency" do
    it "returns currency" do
      expect(subject.currency).to eql "EUR"
    end
  end

  describe "#inspect" do
    it "returns money attributes" do
      expect(subject.inspect).to eql("50.00 EUR")
    end
  end

  describe "#convert_to" do

    it "returns dollars" do
      expect(subject.convert_to("USD").class).to be CurrencyConverter::Money
      expect(subject.convert_to("USD").inspect).to eql("54.00 USD")

    end
  end

  describe "#+" do
    context "when there are the same currency" do
      it "adds currencies" do
        expect((subject + twenty_euros).inspect).to eql("70.00 EUR")
      end
    end

    context "when there are different currency" do
      it "adds currencies" do
        expect((subject + twenty_dollars).inspect).to eql("68.52 EUR")
      end
    end
  end

  describe "#-" do
    context "when there are the same currency" do
      it "subtracs currencies" do
        expect((subject - twenty_euros).inspect).to eql("30.00 EUR")
      end
    end

    context "when there are different currency" do
      it "substracs currencies" do
        expect((subject - twenty_dollars).inspect).to eql("31.48 EUR")
      end
    end
  end

  describe "#/" do
    it "divides currencies" do
      expect((subject / 2).inspect).to eql("25.00 EUR")
    end
  end

  describe "#*" do
    it "divides currencies" do
      expect((subject * 2).inspect).to eql("100.00 EUR")
    end
  end

  describe "#==" do
    context "when there are the same currency" do
      it "compares if it is the same amount" do
        expect(subject == fifty_euros).to be_truthy
      end

      it "compares if it is not the same amount" do
        expect(subject == fifty_two_euros).to be_falsy
      end
    end

    context "when there are different currency" do
      it "compares if it is the same amount" do
        expect(subject == fifty_four_dollars).to be_truthy
      end

      it "compares if it is not the same amount" do
        expect(subject == fifty_two_dollars).to be_falsy
      end
    end
  end

  describe "#>" do
    context "when there are the same currency" do
      it "compares if it is the same amount" do
        expect(subject > fifty_euros).to be_falsy
      end

      it "compares if it is not the same amount" do
        expect(subject > CurrencyConverter::Money.new(40, "EUR")).to be_truthy
      end
    end

    context "when there are different currency" do
      it "compares if it is the same amount" do
        expect(subject > fifty_four_dollars).to be_falsy
      end

      it "compares if it is not the same amount" do
        expect(subject > fifty_two_dollars).to be_truthy
      end
    end
  end

  describe "#<" do
    context "when there are the same currency" do
      it "compares if it is the same amount" do
        expect(subject < fifty_euros).to be_falsy
      end

      it "compares if it is not the same amount" do
        expect(subject < fifty_two_euros).to be_truthy
      end
    end

    context "when there are different currency" do
      it "compares if it is the same amount" do
        expect(subject < fifty_four_dollars).to be_falsy
      end

      it "compares if it is not the same amount" do
        expect(subject < CurrencyConverter::Money.new(56, "USD")).to be_truthy
      end
    end
  end
end
