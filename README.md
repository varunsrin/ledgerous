# Ledger

Ledger is an accounting helper that calculates the smallest set of
payments that will settle open accounts. 
 

## Installation

Add this line to your application's Gemfile:

    gem 'ledger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ledger

## Usage

To use ledger, just require it in your project:

	require 'ledger'

Let's say that Jane paid for Bob's breakfast, Bob paid for Sue's lunch and Sue
paid for Jane's dinner. You'd set the transactions up as follows: 

	transactions = []
	transactions << Transaction.new('Jane', Bob, 20)   # breakfast
	transactions << Transaction.new('Bob', 'Sue', 50)  # lunch
	transactions << Transaction.new('Sue', 'Jane', 35) # dinner

Next, create a new ledger, and add each transaction into the ledger: 

	accounts = Ledger.new
	transactions.each { |t| accounts.reconcile(t) }

You can also set a minimum threshold for debts. Any debts equal to or lower 
than this amount will be discarded:

	accounts.threshold = 2

You can keep adding transactions as they happen. When you're ready to settle accounts, just call: 

	puts accounts.settle



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
