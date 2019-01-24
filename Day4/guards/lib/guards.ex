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
    frequency_map =
      for {^id, _, ranges} <- grouped_entries,
          range <- ranges,
          minute <- range,
          do: minute,
          into: FrequencyMap.new()

    frequency_map
    |> FrequencyMap.max 
  end

  def group_by_minutes_and_id(grouped_entries) do
    Enum.reduce(grouped_entries, %{}, fn {id, _date, _ranges}, minute_id_map ->
      case minute_id_map do
        %{^id => _} -> minute_id_map
        %{} -> 
          result = max_minute_asleep_by_id(grouped_entries, id)
          case result do 
            :error -> minute_id_map
            {max_minute, count} -> Map.put(minute_id_map, id, {max_minute, count})
          end
      end
    end)
    |> IO.inspect(label: "group_by_minutes_and_id")
    |> Enum.max_by(fn {_, {_, count}} -> count end)
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

    {max_minute_asleep, _} = max_minute_asleep_by_id(grouped_entries, guard_id)

    guard_id * max_minute_asleep
  end

  def part2(input) do
    {id, {minute, _}} =
      input
      |> File.read!
      |> process_shift_logs
      |> group_by_minutes_and_id
    id * minute
  end
end
