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
    end

    it 'eliminates single cancel transactions that result in a double cancel second' do 
      # A: 25, B: 50, D: -75, C: 10, E: -10 -> first payment A pays D
    end

    it 'eliminates any transaction third' do
      # A: -25, B: 50, C: -25 -> 2 payments total
    end

    it 'returns an array of payments' do
      subject.reconcile!(Transaction.new('A', 'B', 200))
      subject.reconcile!(Transaction.new('C', 'D', 200))
      expect(subject.settle!.length).to eq(2)
    end

  end

end