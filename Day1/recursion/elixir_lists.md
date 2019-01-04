# Elixir Lists

Lists in Elixir are specified between square brackets:

```elixir
iex > [ 1, "two", 3.14, true ]
[1, "two", 3.14, true]

```

Lists in Elixir are effectively linked lists, which means they are internally represented in pairs containing the head and tail of a list:
```elixir

iex(2)> [head | tail ] = [ +1, -5, +7 ]
[1, -5, 7]
iex(3)> head
1
iex(4)> tail
[-5, 7]

```
If we kept repeating this process, we can traverse the list until we are left with a `[]` empty list. We will use this property to write the recursion needed.

```elixir
iex(5)> [head | tail ] = tail
[-5, 7]
iex(6)> head
-5
iex(7)> tail
'\a'
iex(8)> [head | tail ] = tail
'\a'
iex(9)> head
7
iex(10)> tail
[]
```

In Elixir, functions are identified with their name and arity (i.e. number of parameters ) so that the language can treat these as totally different functions.
Elixir support function declarations with guards and multiple clauses. If a function has several clauses, Elixir will try each clause until it finds the one that matches. We will use this property to create a recurring function that accepts a `([h | t ], number)` and another that matches empty list `([], number)` which will get called as a terminating condition processing the list repeatedly by splitting them into head and tail.

```elixir
    defp sum_frequencies([ freq | frequencies ], current_frequency ) do
        new_frequency = String.to_integer(freq) + current_frequency
        sum_frequencies(frequencies, new_frequency)
    end

    defp sum_frequencies([], current_frequency) do
        current_frequency
    end
```
