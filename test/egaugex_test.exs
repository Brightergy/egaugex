defmodule EgaugexTest do
  use ExUnit.Case

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

    assert result == %{
             attributes: %{
               "columns" => "4",
               "epoch" => "1422034920",
               "time_delta" => "1",
               "time_stamp" => "1462215365"
             },
             data: %{
               "CT1" => ["-8380988951", "-8380987261"],
               "CT2" => ["-9517686129", "-9517684585"],
               "CT3" => ["-8703109347", "-8703107716"],
               "Grid" => ["-26601784427", "-26601779562"]
             }
           }
  end

  test "hex_to_int converts hex to integer correctly" do
    assert Egaugex.Parser.hex_to_int("abcd") === "43981"
    assert Egaugex.Parser.hex_to_int("deadbeef") === "3735928559"
  end
end
