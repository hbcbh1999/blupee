# Blupee

🌀 Blupee is an API wrapper for Ethereum, OmiseGo and many more [ERC20 tokens](https://etherscan.io/tokens). Create wallets, transfer cryptocurrencies and anonimously trade any blockchain asset for another.


## Installation

    $ gem install blupee


## Credentials

[Sign up for a client id](https://blupee.io/clients/new)


## Ethereum, OmiseGo and ERC20 tokens

Authentication

```ruby
require 'blupee'
Blupee::API::Auth.new(client_id='', client_secret='').get_access_token
```

New wallet

```ruby
ether_wallet = Blupee::API::Ether.new_wallet('[hidden]')
```

Ether balance

```ruby
ether_balance = Blupee::API::Ether.balance("0xad96B1072E60f6279F628E7512242F9b1A83127F")
```

Send Ether

```ruby
 Blupee::API::Ether.transfer({:to_address=>"0xE4E3A170843C6fdF2D480592D20eC27985Bc05Dd", :from_address=>"0x7e3513840f6936efe9cc96c279917af6e3be682b", :password=>"[hidden]", :quantity=>0.0001})
```


OmiseGo balance
```ruby
args = {wallet_address:""}
Blupee::API::OmiseGo.balance(args)
```

Send OmiseGo
```ruby
args = {to_address:"", from_address:"", password:"", quantity:0.001}
Blupee::API::OmiseGo.transfer(args)
```


ERC20 token balance
```ruby
args = {wallet_address:"", contract_address:""}
Blupee::API::Token.balance(args)
```

Send ERC20 token
```ruby
args = {to_address:"", from_address:"", password:"", quantity:0.001, contract_address:""}
Blupee::API::Token.transfer(args)
```



## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/fogonthedowns/blupee/issues)
- Fix bugs and [submit pull requests](https://github.com/fogonthedowns/blupee/pulls)
- Write documentation
- Suggest new features
- Add new features

