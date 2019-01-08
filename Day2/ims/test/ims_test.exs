defmodule ImsTest do
  use ExUnit.Case
  doctest Ims

  test "greets the world" do
    assert Ims.hello() == :world
  end

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
end
