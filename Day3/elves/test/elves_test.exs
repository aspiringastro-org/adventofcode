defmodule ElvesTest do
  use ExUnit.Case
  doctest Elves

  test "process multiple claims" do
    {:ok, io_data} = StringIO.open("""
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """
    )
    IO.stream(io_data, :line)
    |> Elves.read_input()
    |> Enum.each( fn x ->
      IO.inspect(x, label: "claim")
      
    end)
  end

  test "process test file with claims" do
    assert Elves.process("data/test.txt") == 4
  end

end