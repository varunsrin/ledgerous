require "ledger/version"
require "transaction"

class Ledger

  attr_reader :accounts

  # Initalize a ledger from a set of transactions
  def initialize(transactions=[])
    @accounts = {}
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
    payments = []
    while !empty?
      p = settle_helper
      payments << p
      reconcile!(p)
    end
    payments
  end

  def settle_helper
    debtors.each do |d|
      creditors.each do |c|
        return Transaction.new(c[0], d[0], c[1])
      end
    end
  end

  private


  def cancellable_accounts
    transactions = []
    debtors.each do |d| 
      creditors.each do |c|
        if d[1] == c[1]
          transactions << Transaction.new(c[0], d[0], c[1])
        end 
      end
    end
    return transactions
  end


  # Returns all debtors
  def debtors
    @accounts.select {|_, amt| amt < 0}
  end

  # Returns all creditors
  def creditors
    @accounts.select {|_, amt| amt > 0}
  end

  # Returns all possible transactions that eliminate a debtor or creditor
  def transactions
    debtors.each do |d|
      creditors.each do |c|
        if c.amount < (-d.amount)
          yield Transaction.new(d, c, c.amount)
        elsif c.amount > (-d.amount) 
          yield Transaction.new(d, c, -d.amount)
        end
      end
    end
  end

  # Updates the account, or creates it if it does not exist
  def update_or_create_account!(name, amount)
    account = name.to_sym
    @accounts[account] = @accounts[account].to_i + amount
  end

  # Reconciles opposing payments and removes them from the ledger, (true/false)
  def clear_even_debts!
    debtors.each do |d|
      creditors.each do |c|
        if c[1] == -d[1]
          reconcile!(Transaction.new(c[0], d[0], c[1])) 
        end
      end
    end
  end

  # If transaction will result in a settle_even_debt success, perform the transaction and remove even debts (true/false)
  def lookahead_and_settle_even_debts!(transaction)
    reconcile!(transaction)
    settled = settle_even_debts!
    reconcile!(transaction.invert!) if !settled
    return settled
  end

end

