defmodule ParserTest do
    use ExUnit.Case
    doctest ShiftParser

    test "parse a guard shift log line" do
        ShiftParser.parse("[1518-11-01 00:00] Guard #10 begins shift")
    end

    test "parse a guard wake up" do
        ShiftParser.parse("[1518-11-01 00:25] wakes up")
    end

    test "parse a guard falls asleep" do
        ShiftParser.parse("[1518-11-01 00:05] falls asleep")
    end
end
