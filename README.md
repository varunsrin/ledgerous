# Ledger

Ledger is a accounting helper module that calculates the set of payments required to resolve open accounts.
 


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

Now create a ledger, and then add some transactions: 

	accounts = Ledger.new

	lunch = Transaction.new('Bob', 'Sue', 50)
	accounts.reconcile!(lunch)

	dinner = Transaction.new('Sue', 'Jane', 35)
	accounts.reconcile!(dinner)
	
	breakfast = Transaction.new('Jane', Bob, 20)
	accounts.reconcile!(breakfast)

You can keep adding transactions as they happen. When you're ready to settle accounts, just call: 

	payments = accounts.settle!

This will return a list of transactions to settle everyones open debts. 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
