defmodule DifferbyTest do
  use ExUnit.Case
  doctest Differby

  test "differ by 2" do
    assert Differby.differ_by?("abcde", "axcye", 2)
  end

  test "scan by 2" do
    assert Differby.scan([
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ], 2) == [{"abcde", "axcye"}]
  end

  test "scan by 1" do
    assert Differby.scan([
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ], 1) == [{"fghij", "fguij"}]
  end

  test "output by 1" do
    [{s1, s2}] = Differby.scan([
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ], 1)

    slist1 = String.to_charlist(s1)
    slist2 = String.to_charlist(s2)
    assert Enum.zip(slist1, slist2)
    |> Enum.filter(fn {x,y} -> x == y end)
    |> Enum.map(fn {x,x} -> x end)
    |> List.to_string()
    == "fgij"

  end

  test "find matching ids" do
    assert Differby.list_matching_ids([
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ], 1) == ["fgij"]
  end
end
