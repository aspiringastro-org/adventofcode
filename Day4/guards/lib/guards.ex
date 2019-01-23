defmodule Guards do
  @moduledoc """
  Documentation for Guards.
  """

  @doc """
  Process shift log records

  """
  def process_shift_logs(logs) do
    logs
    |> String.split("\n", trim: true)
    |> Enum.map(&ShiftParser.parse/1)
    |> Enum.sort
    |> group_by_date_and_id([])
  end

  defp group_by_date_and_id([{date, _hour, _min, {:shift, id}} | rest], groups) do
    {rest, ranges} = get_asleep_ranges(rest, [])
    group_by_date_and_id(rest, [{id, date, ranges} | groups])
  end

  defp group_by_date_and_id([], groups) do
    Enum.reverse(groups)
  end

  defp get_asleep_ranges([{_, _, down_minute, :down},{_, _, up_minute, :up} | rest], ranges) do
    get_asleep_ranges(rest, [ down_minute..(up_minute - 1) | ranges ])
  end

  defp get_asleep_ranges(rest, ranges) do
    {rest, Enum.reverse(ranges)}
  end

  defp aggregate_asleep_time_by_id(grouped_entries) do
    Enum.reduce(grouped_entries, %{}, fn {id, _date, ranges}, acc -> 
      time_slept = Enum.map(ranges, &Enum.count/1) |> Enum.sum
      Map.update(acc, id, time_slept, & &1 + time_slept)
    end)
  end

  defp max_asleep_id_and_mins(aggregated_entries) do
    Enum.max_by(aggregated_entries, fn {_, slept_mins} -> slept_mins end)
  end

  defp max_minute_asleep_by_id(grouped_entries, id) do
    all_mins =
      for {^id, _, ranges} <- grouped_entries,
          range <- ranges,
          minute <- range,
          do: minute

    Enum.reduce(all_mins, %{}, fn minute, acc ->
      Map.update(acc, minute, 1, & &1 + 1)
    end)
    |> Enum.max_by(fn {_, count} -> count end)    
  end

  def part1(input) do

    grouped_entries =
      input
      |> File.read!
      |> process_shift_logs
    
    {guard_id, _} =
    grouped_entries
    |> aggregate_asleep_time_by_id
    |> max_asleep_id_and_mins

    {max_minute_asleep, _} = 
    grouped_entries
    |> max_minute_asleep_by_id(guard_id)

    guard_id * max_minute_asleep
  end
end
