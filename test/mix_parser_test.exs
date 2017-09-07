defmodule MixParserTest do
  use ExUnit.Case
  doctest MixParser

  test "returns map with mix.lock parsed" do
     file     = Path.join(System.cwd(),"mix.lock")
     lockfile = File.read!(file)
     results  = MixParser.Worker.parse_lock_file(lockfile)
     assert is_list(results)
     assert %{name: _name, latest_version: _lt, lock_version: _lv, upgrade_available: _ua} = List.first(results)
  end
end
