defmodule Day1 do
    def final_frequency(file_stream) do
        file_stream
        |> Stream.map(fn line -> 
            {data, _leftover} = Integer.parse(line)
            data
        end)
        |> Enum.sum()
    end

    @doc """
        Returns the Repeated frequency. In some cases, the system will
        reset back to first reading after iterating through arbitrary
        lines of data. In such cases, there is a requirement to cycle the
        input as follows:

        Let's say there is an input like [1,2,3] - the system can reset in 
        many ways such as:
        [1,2,1,2,3] < - reset to first position after reading '2'
        [1,2,3,1,2,3] < - reset to first position after reading entire list

        To handle such cases, we use Stream.cycle() which provides an infinite
        sequence from the provided input list
        Then, we perform a `reduce_while` operation that continues until a frequency
        match is found. It iterates from the current position of enumerable provided
        by Stream.cycle() and calculates frequency. As the frequency is computed, it
        is stored in `current_frequencies` and also inserted into the mapset 
        `acc_frequencies` if it is not seen before. If the `current_frequency` is 
        already a member of `acc_frequencies`, we have found a repeated frequency

    """
    def repeated_frequency(file_stream) do

        file_stream
        |> Stream.map(fn line ->
            {data, _leftover} = Integer.parse(line)
            data
        end)
        |> Stream.cycle()
        |> Enum.reduce_while({0, MapSet.new()}, fn x, {current_frequency, acc_frequencies} ->
            new_frequency = current_frequency + x
            if Enum.member?(acc_frequencies, new_frequency) do
                {:halt, new_frequency}
            else
                {:cont, {new_frequency, MapSet.put(acc_frequencies, new_frequency)}}
            end
        end)
    end
end

case System.argv() do
    ["--test"] ->
        ExUnit.start()

        defmodule Day1Test do
            use ExUnit.Case

            import Day1
            test "final_frequency" do
                {:ok, io} = StringIO.open("""
                            +1
                            -5
                            +7
                            """)
                assert final_frequency(IO.stream(io, :line)) == 3
            end

            test "repeated_frequency" do
                {:ok, io} = StringIO.open("""
                            +1
                            -2
                            +3
                            +1
                            +1
                            -2
                            """)
                assert repeated_frequency(IO.stream(io, :line)) == 2

                assert repeated_frequency([
                    "+3\n", 
                    "+3\n", 
                    "+4\n", 
                    "-2\n", 
                    "-4\n"]) == 10
            end
        end

    input_file when input_file != [] ->
        input_file
        |> File.stream!([], :line)
        |> Day1.final_frequency()
        |> IO.puts

        input_file
        |> File.stream!([], :line)
        |> Day1.repeated_frequency()
        |> IO.puts

    _ ->
        IO.puts :stderr, "we expected a --test argument or a valid file to process frequency"
        System.halt(1)
end




