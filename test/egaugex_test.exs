defmodule EgaugexTest do
  use ExUnit.Case
  require Logger
  doctest Egaugex

  test "create_digest_auth_header creates digest header appropriately" do
    username = "test"
    password = "pwd"
    uri = "/someurl"
    realm = "test realm"

    auth_digest = Egaugex.Auth.create_digest_auth_header(username, password, uri, realm)
    assert Regex.match?(~r/^Digest username="test", realm="test realm", nonce="[0-9a-f]{32}", uri="\/someurl", response="[0-9a-f]{32}", opaque=""$/, to_string(auth_digest))
  end

  test "random_string creates random strings appropriately" do
    refute Egaugex.Auth.random_string(16) == Egaugex.Auth.random_string(16)
    assert String.length(Egaugex.Auth.random_string(16)) === 16
  end

  test "parse_egauge_data parses egauge data correctly" do
    data = """
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE group PUBLIC "-//ESL/DTD eGauge 1.0//EN" "http://www.egauge.net/DTD/egauge-hist.dtd">
    <group serial="0x46fa1cd3">
    <data columns="4" time_stamp="0x5727a2c5" time_delta="1" epoch="0x54c287e8">
     <cname t="P">Grid</cname>
     <cname t="P">CT1</cname>
     <cname t="P">CT2</cname>
     <cname t="P">CT3</cname>
     <r><c>-26601784427</c><c>-8380988951</c><c>-9517686129</c><c>-8703109347</c></r>
     <r><c>-26601779562</c><c>-8380987261</c><c>-9517684585</c><c>-8703107716</c></r>
     </data>
    </group>
    """
    result = Egaugex.Parser.parse_egauge_data(data)
    assert result == %{attributes: %{"columns" => "4", "epoch" => "1422034920", "time_delta" => "1", "time_stamp" => "1462215365"},
      data: %{"CT1" => {"-8380988951", "-8380987261"}, "CT2" => {"-9517686129", "-9517684585"}, "CT3" => {"-8703109347", "-8703107716"},
      "Grid" => {"-26601784427", "-26601779562"}}}
  end

  test "hex_to_int converts hex to integer correctly" do
    assert Egaugex.Parser.hex_to_int("abcd") === "43981"
    assert Egaugex.Parser.hex_to_int("deadbeef") === "3735928559"
  end
end
