defmodule ShiftParser do
    import NimbleParsec

    @moduledoc """
    Parser for reading the guard shift logs
    """       
    guard_shift_command =
        ignore(string("Guard #"))
        |> unwrap_and_tag(integer(min: 1), :shift)
        |> ignore(string(" begins shift"))

    guard_up_command =
        string("wakes up")
        |> replace(:up)

    guard_down_command =
        string("falls asleep")
        |> replace(:down)

    defparsecp :parsec_log,
        ignore(string("["))
        |> integer(4) # year
        |> ignore(string("-"))
        |> integer(2) # month
        |> ignore(string("-"))
        |> integer(2) # day
        |> ignore(string(" "))
        |> integer(2) # hour
        |> ignore(string(":"))
        |> integer(2) # minute
        |> ignore(string("] "))
        |> choice([guard_shift_command, guard_up_command, guard_down_command]), debug: true

        
    def parse(log) when is_binary(log) do
        case parsec_log(log) do
            {:ok, [year, month, day, hour, min, {action, id}], "", _, _, _} -> {{year, month, day}, hour, min, {action, id}}
            {:ok, [year, month, day, hour, min, action], "", _, _, _} -> {{year, month, day}, hour, min, action}
        end
    end


end