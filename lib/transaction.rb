# Transaction
# A single transaction

class Transaction

  attr_reader :debtor, :creditor, :amount

  def initialize(debtor, creditor, amount)
    @debtor = debtor
    @creditor = creditor
    @amount = amount
  end

  # Reverses the debtor and creditor
  def invert!
    @debtor, @creditor = @creditor, @debtor
  end

  def to_s
    return @debtor + " pays " + " $" + @amount + " to " + @creditor
  end

end
