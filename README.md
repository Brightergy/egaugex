# Egaugex [![Hex version](https://img.shields.io/hexpm/v/egaugex.svg "Hex version")](https://hex.pm/packages/egaugex) ![Hex downloads](https://img.shields.io/hexpm/dt/egaugex.svg "Hex downloads") [![Build Status](https://semaphoreci.com/api/v1/techgaun/egaugex/branches/master/badge.svg)](https://semaphoreci.com/techgaun/egaugex) [![Coverage Status](https://coveralls.io/repos/github/Brightergy/egaugex/badge.svg?branch=master)](https://coveralls.io/github/Brightergy/egaugex?branch=master)
> Gets and parses egauge data given the egauge device id.

## Installation

The package can be installed from hex as:

  1. Add egaugex to your list of dependencies in `mix.exs`:

        def deps do
          [{:egaugex, "~> 0.0.1"}]
        end

## Usage

```elixir
import Egaugex

# hits `/cgi-bin/egauge-show?S&n=60` by default
egauge_parser("egaugexxxxx")

# with username and password auth
egauge_parser("egaugexxxxx", ["username": "owner", "password": "default"])

# with custom uri
egauge_parser("egauge17983", [{:uri, "/cgi-bin/egauge-show?S&a&t=1462299644"}, {:username, "owner"}, {:password, "default"}])
```

You can pass the list of arguments as keyword arguments as shown in example above. The other keyword arguments are `base_url` and `realm`.
