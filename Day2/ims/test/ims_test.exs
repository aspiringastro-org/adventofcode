defmodule ImsTest do
  use ExUnit.Case
  doctest Ims

  test "read box ID file" do
    Ims.read_box_ids([
      "agirmcjvluedbsyoqozuknwxwt\n",
      "afirmcjwlhedxsyoqfzuknpxwt\n",
      "agirmcjvlhefbsyoqfkuinpxwt\n",  
      "agirycjvltedbsypqfzuknpxwt\n",
      "agirmrxvlhedbsyoqfzeknpxwt\n",
      "agfrmcqvlhedbsyoqxzuknpxwt\n",
      "agormcjvuhexbsyoqfzuknpxwt\n",
      "agyrmcjvehddbsyoqfzuknpxwt\n",
      "agirmcjvlheqbsynqfzgknpxwt\n",
      "agirmcjvlhedbsloufwuknpxwt\n",
      "tgirmcjvlwedbsyoqfzuknpqwt\n"
    ])
  end

  test "mapping and counting letters" do
    result = Ims.map_letter_ids("hello")
    assert result == %{"e" => 1, "h" => 1, "l" => 2, "o" => 1}
    assert result == Ims.count_characters("hello")

    result = Ims.map_letter_ids("banana")
    assert result == %{"a" => 3, "b" => 1, "n" => 2}
    assert result == Ims.count_characters("banana")

    result = Ims.map_letter_ids("elixir")
    assert result == %{"e" => 1, "i" => 2, "l" => 1, "r" => 1, "x" => 1}
    assert result == Ims.count_characters("elixir")

  end

  test "map_letter_ids with UTF-8" do
    result = Ims.map_letter_ids("仙薬")
    assert  result == %{"仙" => 1, "薬" => 1}
    assert result == Ims.count_characters("仙薬")    
  end
end
