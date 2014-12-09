require "ledgerous/version"
require "transaction"

class Ledgerous

  attr_reader :accounts, :payments

  attr_accessor :threshold

  def initialize
    @accounts = Hash.new(0)
    @threshold = 0
  end

  # Returns true if there are no open accounts above or below the threshold
  def empty?
    @accounts.each do |k, v| 
      return false if v.abs > @threshold
    end
    return true
  end

  # Returns all accounts with negative balances
  def debtors
    @accounts.select {|_, amt| amt < 0}
  end

  # Returns all accounts wiht positive balances
  def creditors
    @accounts.select {|_, amt| amt > 0}
  end

  # Reconciles the ledgerous with the transaction
  def reconcile(t)
    update_or_create_account(t.creditor, t.amount)
    update_or_create_account(t.debtor, -t.amount)
  end

  # Returns list of transactions that will settle open accounts
  def settle
    s = Marshal.load(Marshal.dump(self))
    s.settle!
  end

  # Returns a list of transactions that will settle open accounts, and applies
  # them to clear accounts
  def settle!
    payments = []
    next_payment do |n|
      reconcile(n)
      payments << n.reverse
    end
    payments
  end

  protected

  # Returns the first payment that can clear two accounts
  def double_clear_payment
    debtors.each do |d| 
      creditors.each do |c|
        return Transaction.new(c[0], d[0], c[1]) if c[1] == -d[1]
      end
    end
    return false
  end

  # Returns the first payment that clears one account, but will result in two 
  # accounts being cleared next
  def double_clear_lookahead
    s = Marshal.load(Marshal.dump(self))
    s.single_clears do |p|
      s.reconcile(p)
      s.double_clear_payment ? (return p) : s.reconcile(p.reverse)     
    end
    return false
  end

  # Yields payments that will clear one account
  def single_clears
    debtors.each do |d|
      creditors.each do |c|
        yield Transaction.new(c[0], d[0], [c[1], -d[1]].min)
      end
    end
  end

  # Returns the first payment that will clear one account
  def single_clear
    single_clears { |n| return n }
  end

  private

  # Updates the account, or creates it if it does not exist
  def update_or_create_account(name, amount)
    @accounts[name.to_sym] += amount
  end

  # Finds the next best payment to settle the account
  #
  # * Cancel a payment that removes two accounts
  # * Cancel a payment that removes one account, but will result in two being
  #   removed on the next payment
  # * Cancel a payment that removes any account
  def next_payment
    until empty?      
      if double_clear_payment
        yield double_clear_payment
        next
      end
      yield double_clear_lookahead ? double_clear_lookahead : single_clear
    end
  end

end
