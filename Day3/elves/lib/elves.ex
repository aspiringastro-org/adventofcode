defmodule Elves do
  @moduledoc """
  Documentation for Elves.
  """


  def read_input(input_stream) do
    input_stream
    |> Stream.map(fn x -> String.split(x, "\n", trim: true) end)
    |> Enum.flat_map(fn x -> process_claims(x) end)
  end

  def process_claims(claims) do
    decode_claims(claims)
  end

  defp decode_claims([first | rest]) do
    [id,left,top,width,height] =   
      String.splitter(first, ["#", " ", "@", ",", "x", ":"], trim: true) 
      |> Enum.take(5)
      |> Enum.map(&String.to_integer/1)

    locations = 
      for x <- left..left+width-1, y <- top..top+height-1 do
        {x+1,y+1}
      end

    [ {id, MapSet.new(locations)} | decode_claims(rest) ]
  end

  defp decode_claims([]) do
    []
  end

  def intersecting_claims([{_id, first} | rest]) do
    intersect = 
      Enum.reduce(rest, MapSet.new(), fn({_id, x}, acc) ->
        MapSet.intersection(first, x)
        |> MapSet.union(acc)
      end)
      if MapSet.size(intersect) > 0 do
        [ intersect | intersecting_claims(rest) ]
      else
        intersecting_claims(rest)
      end
  end

  def intersecting_claims([]) do
    []
  end

  def find_disjoint_claim(claims) do
    claims
    |> Enum.filter(fn {id_first, first} ->
        selected = Enum.filter(claims, fn({id, _}) -> id != id_first end)
        Enum.all?(selected, fn({_, next}) -> MapSet.disjoint?(first, next) end)
      end)
  end
 
  def process(input_file) do
      input_file
      |> File.stream!([], :line)
      |> read_input()
      |> intersecting_claims()
      |> IO.inspect(label: "intersecting claims")
      |> Enum.reduce(MapSet.new(), fn(x, acc) -> MapSet.union(acc, x) end)
      |> IO.inspect(label: "all claims")
      |> MapSet.to_list()
      |> Enum.count()
      |> IO.inspect(label: "area")

      input_file
      |> File.stream!([], :line)
      |> read_input()
      |> find_disjoint_claim()
      |> IO.inspect(label: "non-overlapping claim")
  end

end
