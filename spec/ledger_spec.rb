require 'spec_helper'

describe Ledger do
  subject { Ledger.new }

  describe '#empty?' do

    it 'returns true if the ledger is empty' do
      expect(subject.empty?).to eq(true)
    end

    it 'returns false if the ledger has any accounts' do
      subject.reconcile!(Transaction.new('A', 'B', 200))
      expect(subject.empty?).to eq(false)
    end

    it 'returns true if no accounts are greater than the threshold' do
      subject.reconcile!(Transaction.new('A', 'B', 5))
      expect(subject.empty?(5)).to eq(true)
    end

  end

  describe '#reconcile!' do

    it 'adds two accounts to the ledger' do
      subject.reconcile!(Transaction.new('A', 'B', 200))
      expect(subject.accounts.length).to eq(2)
      expect(subject.accounts[:A]).to eq(-200)
      expect(subject.accounts[:B]).to eq(200)
    end

    it 'updates accounts if they already exist' do
      2.times do
        subject.reconcile!(Transaction.new('A', 'B', 200))
      end
      expect(subject.accounts.length).to eq(2)
      expect(subject.accounts[:A]).to eq(-400)
      expect(subject.accounts[:B]).to eq(400)
    end

  end

  describe '#settle!' do

    it 'eliminates double cancel transactions first' do
      subject.reconcile!(Transaction.new('A', 'D', 5))
      subject.reconcile!(Transaction.new('B', 'D', 10))
      subject.reconcile!(Transaction.new('C', 'E', 25))
      # E: 25, B: -10, C: -25, D: 15, A: -5
      subject.settle!
      expect(subject.payments[0].debtor).to eql(:C)
      expect(subject.payments[0].creditor).to eql(:E)
      expect(subject.payments[0].amount).to eql(25)
    end

    it 'eliminates single cancel transactions that result in a double cancel second' do 
      # A: 10, B: -2, C: -12, D:4, E: 25, F: 50, G: -75  -> first payment E pays G
      subject.reconcile!(Transaction.new('B', 'A', 2))
      subject.reconcile!(Transaction.new('C', 'A', 8))
      subject.reconcile!(Transaction.new('C', 'D', 4))
      subject.reconcile!(Transaction.new('G', 'E', 25))
      subject.reconcile!(Transaction.new('G', 'F', 50))
      subject.settle!
      expect(subject.payments[0].debtor).to eql(:G)
      expect(subject.payments[0].creditor).to eql(:E)
      expect(subject.payments[0].amount).to eql(25)
    end

    it 'eliminates any transaction third' do
      subject.reconcile!(Transaction.new('B', 'A', 2))
      subject.reconcile!(Transaction.new('C', 'A', 8))
      subject.reconcile!(Transaction.new('C', 'D', 4))
    end

    it 'returns an array of payments' do
      subject.reconcile!(Transaction.new('A', 'B', 200))
      subject.reconcile!(Transaction.new('C', 'D', 200))
      subject.settle!
      expect(subject.payments.length).to eq(2)
    end

  end

end