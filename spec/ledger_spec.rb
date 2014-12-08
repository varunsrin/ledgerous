require 'spec_helper'

describe Ledger do
  subject { Ledger.new }

  describe '#empty?' do

    it 'returns true if the ledger is empty' do
      expect(subject.empty?).to eq(true)
    end

    it 'returns false if the ledger has any accounts' do
      subject.reconcile(Transaction.new('A', 'B', 5))
      expect(subject.empty?).to eq(false)
    end

    it 'returns true if no accounts are greater than the threshold' do
      subject.reconcile(Transaction.new('A', 'B', 5))
      expect(subject.empty?(5)).to eq(true)
    end

  end

  describe '#reconcile' do

    before :each do
      subject.reconcile(Transaction.new('A', 'B', 20))
    end

    it 'adds two accounts to the ledger' do
      expect(subject.accounts.length).to eq(2)
      expect(subject.accounts[:A]).to eq(-20)
      expect(subject.accounts[:B]).to eq(20)
    end

    it 'updates accounts if they already exist' do
      subject.reconcile(Transaction.new('A', 'B', 20))
      expect(subject.accounts.length).to eq(2)
      expect(subject.accounts[:A]).to eq(-40)
      expect(subject.accounts[:B]).to eq(40)
    end

    it 'eliminates transitive debts' do
      subject.reconcile(Transaction.new('B', 'C', 20))
      expect(subject.debtors.length && subject.creditors.length).to eq(1)
    end
  end


  describe '#settle' do

    before do 
      # A: 10, B: -2, C: -12, D:4, E: 25, F: 50, G: -75, H: 7, I: -7
      subject.reconcile(Transaction.new('B', 'A', 2))
      subject.reconcile(Transaction.new('C', 'A', 8))
      subject.reconcile(Transaction.new('G', 'E', 25))
      subject.reconcile(Transaction.new('G', 'F', 50))
      subject.reconcile(Transaction.new('C', 'D', 4))
      subject.reconcile(Transaction.new('I', 'H', 7))
      @payments = subject.settle
    end

    it 'chooses one payment that cancels two accounts first' do
      expect(@payments[0]).to eq(Transaction.new(:I, :H, 7))
    end

    it 'chooses two payments that cancel three accounts second' do
      expect(@payments[1]).to eq(Transaction.new(:G, :E, 25))
      expect(@payments[2]).to eq(Transaction.new(:G, :F, 50))
    end

    it 'chooses one payment that cancels one account next' do 
      expect(@payments[3]).to eq(Transaction.new(:B, :A, 2))
    end

  end

end