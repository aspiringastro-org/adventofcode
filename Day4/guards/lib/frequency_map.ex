defmodule FrequencyMap do
    defstruct data: %{}

    def new() do
        %FrequencyMap{}
    end

    def max(%FrequencyMap{data: data}) do
        if data != %{} do
            Enum.max_by(data, fn {_, count} -> count end)
        else
            :error
        end
    end
    
    defimpl Collectable do
        def into(%FrequencyMap{data: data}) do
          collector_fun = fn
            data, {:cont, elem} -> Map.update(data, elem, 1, & &1 + 1)
            data, :done -> %FrequencyMap{data: data}
            _data, :halt -> :ok
          end
  
          {data, collector_fun}
        end
    end
end