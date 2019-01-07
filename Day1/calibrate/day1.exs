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
        Repeated frequency 

    ## Examples
  

    """
    def repeated_frequency(file_stream) do
        file_stream
        |> Stream.map(fn line ->
            {data, _leftover} = Integer.parse(line)
            data
        end)
        |> Stream.cycle()
        |> Enum.reduce_while({0, []}, fn x, {current_frequency, acc_frequencies} ->
            new_frequency = current_frequency + x
            if Enum.member?(acc_frequencies, new_frequency) do
                {:halt, new_frequency}
            else
                {:cont, {new_frequency, [ new_frequency | acc_frequencies ]}}
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




