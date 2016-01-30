require "pstore"

module CurrencyConverter
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
          self.class.new(
            @rates[currency_to_convert] * amount,
            currency_to_convert
          )
        end
      end
    end

    def self.conversion_rates(base_currency, currency_rates)
      rates = PStore.new("rates.pstore")

      rates.transaction do
        rates[base_currency] = BASE_CURRENCY
        currency_rates.each_pair { |currency, value| rates[currency] = value }
        rates.commit
      end
    end

    def +(money_object)
      self.class.new(@amount + amount_converted(money_object), @currency)
    end

    def -(money_object)
      self.class.new(@amount - amount_converted(money_object), @currency)
    end

    def /(number)
      self.class.new(@amount / number, @currency)
    end

    def *(number)
      self.class.new(@amount * number, @currency)
    end

    def ==(money_object)
      @amount == amount_converted(money_object)
    end

    def >(money_object)
      @amount > amount_converted(money_object)
    end

    def <(money_object)
      @amount < amount_converted(money_object)
    end

    private

    def amount_converted(money_object)
      money_object.convert_to(@currency).amount
    end

  end
end
