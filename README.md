# MixParser

**TODO: Add description**
{:ok,  {{_httpv, 200, _}, headers, body}} = :httpc.request(:get, {'https://api.github.com/repos/bradleyd/fingerprint/contents/mix.lock',[{'User-Agent', 'octokat'}]}, [], []) 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mix_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mix_parser, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mix_parser](https://hexdocs.pm/mix_parser).

