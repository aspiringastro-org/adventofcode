defmodule Day1 do
    def final_frequency(input) do
        input
        |> String.split("\n", trim: true)
        |> IO.inspect(label: "split")
        |> Enum.map(fn line -> String.to_integer(line) end)
        |> IO.inspect(label: "mapped")
        |> Enum.sum
    end

end

case System.argv() do
    ["--test"] ->
        ExUnit.start()

        defmodule Day1Test do
            use ExUnit.Case

            import Day1
            test "final_frequency" do
    
                assert final_frequency("""
                        +1
                        -5
                        +7
                        """) == 3
            end
        end

    input_file when input_file != [] ->
        input_file
        |> File.read!()
        |> Day1.final_frequency()
        |> IO.puts

    _ ->
        IO.puts :stderr, "we expected a --test argument or a valid file to process frequency"
        System.halt(1)
end




