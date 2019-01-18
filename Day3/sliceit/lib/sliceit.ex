defmodule Sliceit do
  @moduledoc """
  Documentation for Sliceit.
  """
  @type claim :: String.t
  @type parsed_claim :: list
  @type coordinate :: {pos_integer, pos_integer}
  @type id :: pos_integer  


  @doc """
  Hello world.

  ## Examples

      iex> Sliceit.hello()
      :world

  """
  def hello do
    :world
  end

  # parse claims into a 5-tuple
  # large map of {x,y} coorindates => 1
  #  

  @doc """
  Parses a claim

  ## Examples

      iex> Sliceit.parse_claim("#1 @ 100,320 : 4x10")
      [1, 100, 320, 4, 10]

  """
  def parse_claim(claim_str) when is_binary(claim_str) do
    claim_str
    |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> IO.inspect
  end

  @doc """
  Retrieves all claimed inches

  ## Examples

      iex> claimed = Sliceit.claimed_inches([ "#1 @ 1,3 : 4x4", "#2 @ 3,1 : 4x4", "#3 @ 5,5 : 2x2"])
      iex> claimed[{4,2}]
      [2]
      iex> claimed[{4,4}] |> Enum.sort 
      [1, 2]
      
  """
  @spec claimed_inches([claim]) :: %{coordinate => [id]}
  def claimed_inches(claims) do
    Enum.reduce(claims, %{}, fn claim, acc ->
      [id, left, top, width, height] = parse_claim(claim)

      Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  @doc """
  Retrieves all overlapped inches

  ## Examples

      iex> Sliceit.overlapped_inches([ "#1 @ 1,3 : 4x4", "#2 @ 3,1 : 4x4", "#3 @ 5,5 : 2x2"])
      [{4,4}, {4,5}, {5,4}, {5,5}]

  """
  @spec overlapped_inches([claim]) :: [coordinate]
  def overlapped_inches(claims) do
    # Map from the claimed_inches is read and pattern matched to select
    # only coordinates that match the condition of two or more claims in a 
    # single step.
    # { coordinate, [_, _ | _ ] } implies select only key value pairs where
    # the value is a list containing at least two elements.
    # Return coordinate from the do block (compact `for expr, do:` expression)
    for {coordinate, [_, _ | _]} <- claimed_inches(claims), do: coordinate
  end

end