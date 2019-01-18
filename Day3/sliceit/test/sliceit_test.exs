defmodule SliceitTest do
  use ExUnit.Case
  doctest Sliceit

  test "greets the world" do
    assert Sliceit.hello() == :world
  end
end
