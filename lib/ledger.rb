require "ledger/version"
require "transaction"

class Ledger

  attr_reader :accounts, :payments

  # Initalize a ledger from a set of transactions
  def initialize(transactions=[])
    @accounts = {}
    @payments = []
    transactions.each do |t|
      reconcile!(t)
    end
  end

  # Checks if any accounts in ledger with a balance over the threshold
  def empty?(threshold=0)
    @accounts.each do |k, v| 
      return false if v.abs > threshold
    end
    return true
  end

  # Reconciles the ledgers accounts with the transaction
  def reconcile!(transaction)
    update_or_create_account!(transaction.creditor, transaction.amount)
    update_or_create_account!(transaction.debtor, -transaction.amount)
  end

  # Returns list of transactions that will settle open accounts
  def settle!
    while !empty?      
      transact(even_account) while even_account
      transact(any_account) while any_account
    end
  end

  def even_account
    debtors.each do |d| 
      creditors.each do |c|
        return Transaction.new(c[0], d[0], c[1]) if c[1] == -d[1]
      end
    end
    return false
  end

  def any_account
    debtors.each do |d|
      creditors.each do |c|
        amount = c[1] > -d[1] ? -d[1] : c[1]  
        return Transaction.new(c[0], d[0], amount)
      end
    end
    return false
  end

  def transact(t)
    reconcile!(t)
    t.invert!
    @payments << t
  end

  # Returns all debtors
  def debtors
    @accounts.select {|_, amt| amt < 0}
  end

  # Returns all creditors
  def creditors
    @accounts.select {|_, amt| amt > 0}
  end

  # Updates the account, or creates it if it does not exist
  def update_or_create_account!(name, amount)
    account = name.to_sym
    @accounts[account] = @accounts[account].to_i + amount
  end

end

