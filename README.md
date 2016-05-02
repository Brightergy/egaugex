# Egaugex [![Build Status](https://semaphoreci.com/api/v1/techgaun/egaugex/branches/master/badge.svg)](https://semaphoreci.com/techgaun/egaugex) [![Coverage Status](https://coveralls.io/repos/github/Brightergy/egaugex/badge.svg?branch=master)](https://coveralls.io/github/Brightergy/egaugex?branch=master)
> Gets and parses egauge data given the egauge device id.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add egaugex to your list of dependencies in `mix.exs`:

        def deps do
          [{:egaugex, "~> 0.0.1"}]
        end

  2. Ensure egaugex is started before your application:

        def application do
          [applications: [:egaugex]]
        end

## Usage

```elixir
import Egaugex

egauge_parser("egaugexxxxx")

# with username and password auth
egauge_parser("egaugexxxxx", "owner", "default")
```
