require "pstore"

class Money

  BASE_CURRENCY = 1.00

  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
    @rates = PStore.new("rates.pstore")
  end


  def inspect
    "#{sprintf("%.2f", amount)} #{currency}"
  end

  def convert_to(currency_to_convert)
    @rates.transaction do
      if @rates[currency_to_convert] == BASE_CURRENCY
        self.class.new(amount / @rates[@currency], currency_to_convert)
      else
        self.class.new(@rates[currency_to_convert] * amount, currency_to_convert)
      end
    end
  end

  def self.conversion_rates(base_currency, currency_rates)
    rates = PStore.new("rates.pstore")

    rates.transaction do
      rates[base_currency] = BASE_CURRENCY
      currency_rates.each_pair do |currency, value|
        rates[currency] = value
      end
      rates.commit
    end
  end

  def +(currency_b)
    self.class.new(@amount + currency_b.convert_to(@currency).amount, @currency)
  end

  def -(currency_b)
    self.class.new(@amount - currency_b.convert_to(@currency).amount, @currency)
  end

  def /(number)
    self.class.new(@amount / number, @currency)
  end

  def *(number)
    self.class.new(@amount * number, @currency)
  end

  def ==(currency_b)
    @amount == currency_b.convert_to(@currency).amount
  end

  def >(currency_b)
    @amount > currency_b.convert_to(@currency).amount
  end

  def <(currency_b)
    @amount < currency_b.convert_to(@currency).amount
  end
end
