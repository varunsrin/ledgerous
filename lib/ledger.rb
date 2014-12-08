require "ledger/version"
require "transaction"

class Ledger

  attr_reader :accounts, :payments

  def initialize
    @accounts = {}
  end

  # Checks if any accounts in ledger with a balance over the threshold
  def empty?(threshold=0)
    @accounts.each do |k, v| 
      return false if v.abs > threshold
    end
    return true
  end

  # Returns all debtors
  def debtors
    @accounts.select {|_, amt| amt < 0}
  end

  # Returns all creditors
  def creditors
    @accounts.select {|_, amt| amt > 0}
  end

  # Reconciles the ledgers accounts with the transaction
  def reconcile(t)
    update_or_create_account(t.creditor, t.amount)
    update_or_create_account(t.debtor, -t.amount)
  end

  # Returns list of transactions that will settle open accounts
  def settle
    s = Marshal.load(Marshal.dump(self))
    s.settle!
  end

  def settle!
    payments = []
    next_payment do |n|
      reconcile(n)
      payments << n.reverse
    end
    payments
  end

  protected

  def single_cancel_payments
    debtors.each do |d|
      creditors.each do |c|
        yield Transaction.new(c[0], d[0], [c[1], -d[1]].min)
      end
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

  private

  def any_account
    single_cancel_payments { |n| return n }
  end

  # Updates the account, or creates it if it does not exist
  def update_or_create_account(name, amount)
    account = name.to_sym
    @accounts[account] = @accounts[account].to_i + amount
  end

  def next_payment
    until empty?      
      if even_account
        yield even_account
        next
      end
      yield even_after_one_account ? even_after_one_account : any_account
    end
  end

  def even_after_one_account
    s = Marshal.load(Marshal.dump(self))
    s.single_cancel_payments do |p|
      s.reconcile(p)
      s.even_account ? (return p) : s.reconcile(p.reverse)     
    end
    return false
  end

end
