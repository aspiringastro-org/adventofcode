defmodule Alchemix do
  @moduledoc """
  Documentation for Alchemix.
  """

  @doc """

      iex> Alchemix.react("dabAcCaCBAcCcaDA")
      "dabCBAcaDA"

  """
  def react(polymer) when is_binary(polymer), 
    do: react(polymer, [])

  defp react(<<letter1, rest::binary>>, [letter2 | acc]) when abs(letter1 - letter2) == 32,
    do: react(rest, acc)

  defp react(<<letter, rest::binary>>, acc),
    do: react(rest, [letter | acc])

  defp react(<<>>, acc),
    do: acc |> Enum.reverse() |> List.to_string()

  @doc """

      iex> Alchemix.discard_and_react("dabAcCaCBAcCcaDA", ?A, ?a)
      "dbCBcD"

  """
  def discard_and_react(polymer, letter1, letter2) 
    when is_binary(polymer) do
    discard_and_react(polymer, [], letter1, letter2)
  end
  
  defp discard_and_react(<<letter1, rest::binary>>, acc, discard1, discard2)
    when letter1 == discard1
    when letter1 == discard2 do
      discard_and_react(rest, acc, discard1, discard2)      
  end
    

  defp discard_and_react(<<letter1, rest::binary>>, [letter2 | acc], discard1, discard2) when abs(letter1 - letter2) == 32,
    do: discard_and_react(rest, acc, discard1, discard2)

  defp discard_and_react(<<letter, rest::binary>>, acc, discard1, discard2),
    do: discard_and_react(rest, [letter | acc], discard1, discard2)

  defp discard_and_react(<<>>, acc, _discard1, _discard2),
    do: acc |> Enum.reverse() |> List.to_string()

  @doc """

      iex> Alchemix.find_shortest_polymer("dabAcCaCBAcCcaDA")
      {?C, 4}

  """
  def find_shortest_polymer(polymer) do
    for letter <- ?A..?Z do
      {letter, discard_and_react(polymer, letter, letter + 32) |> byte_size() }
    end
    |> Enum.min_by(fn {_letter, count} -> count end)
  end


  

end
