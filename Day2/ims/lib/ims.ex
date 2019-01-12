defmodule Ims do
  @moduledoc """
  Documentation for Ims.
  """


  def read_box_ids(input_stream) do
    input_stream
    |> Stream.map(fn x -> String.split(x, "\n", trim: true) end)
    |> Enum.map(fn [x] -> count_characters(x) end)    
  end


  @doc """
  Map the characters in ID string and build a map that counts letters in box IDs
  
  We take the boxIDs string and convert it into unicode graphemes. Then, we reduce
  it by creating an empty map `%{} as initialization value and calling reduce with 
  each character retrieved from the string. 

  Note the use of pattern matching here for idiomatic behavior that I'm still learning
  in Elixir - It uses the `{^char => count} pin operator to pattern match an existing key
  `char` in the map and if that `char` exists, the count is bound to the value stored in the
  map. On the right hand side, notice the use of the map append operator `|` to insert/update
  the new value by incrementing it by 1 into the map. As per functional convention, the 
  updated value is present in the new map and the original input is unaffected


  ## Examples

      iex> Ims.map_letter_ids("hello")
      %{"e" => 1, "h" => 1, "l" => 2, "o" => 1}

  """
  def map_letter_ids(id) do
    id
    |> String.graphemes
    |> Enum.reduce(%{}, fn char, acc ->
        case acc do
          %{^char => count} -> %{ acc | char => count + 1}
          _ -> Map.put(acc, char, 1)
        end
    end)
  end

  # More succint option to count characters that uses the Map.update
  # method and further uses the compact notation of passing an anonymous
  # function through the use of `&(&1 + 1)`
  # A sample execution in iex shows:
  #
  # iex> &(&1 + 1)
  # #Function<6.128620087/1 in :erl_eval.expr/5>
  #
  def count_characters(string) when is_binary(string) do
    string
    |> String.graphemes
    |> Enum.reduce(%{}, fn codepoint, acc ->
        Map.update(acc, codepoint, 1, &(&1 + 1))
      end)
  end
  
  defp ids_match_count?(mapped_id, count) do
    mapped_id
    |> Enum.filter(fn {_k, v} -> v == count end)
    |> Enum.count() > 0
  end

  def filter_repeated_letter_ids(mapped_ids, count) do
    mapped_ids
    |> Enum.filter( fn x -> ids_match_count?(x, count) end)
    |> Enum.count()
  end


  def main(input_file) do

    mapped_box_ids = 
      input_file
      |> File.stream!([], :line)
      |> read_box_ids
  
    exactly_two = 
      mapped_box_ids 
      |> filter_repeated_letter_ids(2)

    exactly_three = 
      mapped_box_ids
      |> filter_repeated_letter_ids(3)

    IO.puts "box IDs with exactly 2 : #{exactly_two}, exactly 3 : #{exactly_three}, checksum: #{exactly_two * exactly_three} "
  end

end
