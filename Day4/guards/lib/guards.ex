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
  end
  
end
