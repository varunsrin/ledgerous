# Transaction
# A single transaction

class Transaction

  attr_reader :debtor, :creditor, :amount

  def initialize(debtor, creditor, amount)
    @debtor = debtor
    @creditor = creditor
    @amount = amount
  end

  def reverse
    return Transaction.new(@creditor, @debtor, @amount)
  end

  def ==(obj)
    return obj.amount == self.amount && obj.creditor == self.creditor && obj.debtor == self.debtor
  end

end
