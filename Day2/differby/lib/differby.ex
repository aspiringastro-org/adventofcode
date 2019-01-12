defmodule Differby do
  @moduledoc """
  Documentation for Differby.
  """

  def differ_by?(str1, str2, count) when  is_binary(str1) and is_binary(str2) and is_number(count) do

    # Enum.zip takes two list and returns a single list of tuples containing each element of both list, like
    # [ {x1, x2}, {y1, y2}, ... ]
    # We compare if these tuples match and select only non-matching items and count them. If the count matches
    # difference count requested, this function returns true.
    count ==
      Enum.zip(String.to_charlist(str1), String.to_charlist(str2))
      |> Enum.filter(fn {x,y} -> x != y end )
      |> Enum.count()
  end

  def scan(list, count) do
    scanp(list, count, [])
  end

  defp scanp([head | tail], count, matched_ids) do
    result = 
    tail 
      |> Enum.filter(fn x -> differ_by?(x, head, count) end)
      |> Enum.reduce([], fn x, acc -> [{head,x}] ++ acc  end)
    scanp(tail, count, result ++ matched_ids)
  end

  defp scanp([], _count, result) do
    result
  end

  def list_matching_ids(list, count) when is_list(list) and is_number(count) do
    scan(list, count)
    |> Enum.map( fn {s1, s2} ->  
      Enum.zip(String.to_char_list(s1), String.to_char_list(s2)) 
      |> Enum.filter(fn {x,y} -> x == y end)
      |> Enum.map(fn {x,x} -> x end)
      |> List.to_string()
    end)
  end
end
