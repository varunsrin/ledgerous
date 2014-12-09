# Transaction
# A single transaction

class Transaction

  attr_reader :debtor, :creditor, :amount

  def initialize(debtor, creditor, amount)
    @debtor = debtor
    @creditor = creditor
    @amount = amount
  end

  # Returns a transaction that is the reverse of the current one
  def reverse
    Transaction.new(@creditor, @debtor, @amount)
  end

  def ==(obj)
    (
      obj.amount == self.amount && 
      obj.creditor == self.creditor && 
      obj.debtor == self.debtor
    )
  end

end
