functions


  def first(foo, bar), do: "#{foo} and #{bar}"
  def first(foo), do: "Only #{foo}"

  koan "Functions with the same name are distinguished by the number of arguments they take" do
    assert first("One", "Two") == "One and Two"
    assert first("One") == "One"
  end



  koan "Little anonymous functions are common, and called with a dot" do
    multiply = fn a, b -> a * b end
    assert multiply.(2, 3) == 6
  end

  koan "You can even go shorter, by using capture syntax `&()` and positional arguments" do
    multiply = &(&1 * &2)
    assert multiply.(2, 3) == 6
  end












https://elixircasts.io/
https://hexdocs.pm/elixir/master/naming-conventions.html
https://youtu.be/lxYFOM3UJzo



A word on Tuples (in Python)
# Q1: I think you would for memory allocation or when instruction order is important.
# They’re immutable, so it’s allocated all at once. You also can group data together without having to make a class for it.

Elixir Operators
https://elixir-lang.org/getting-started/basic-operators.html

Pattern Matching
  # koan "Lists must match exactly" do
  #   assert_raise ___, fn ->
  #     [a, b] = [1, 2, 3]
  #   end
  # end
Pattern Matching: https://youtu.be/48X5aGwBnzQ
Also this: https://youtu.be/pAmzqyq_Yzg

Matches need to match in form sequence and in length
x = 1
1 = x

x = 1
^x = 2

Underscore variables!!

  koan "So does the keyword lists" do
    kw_list = [type: "car", year: 2016, make: "Honda"]
    [_type | [_year | [tuple]]] = kw_list
    assert tuple == {:make, "Honda"}
  end

  koan "The pattern can make assertions about what it expects" do
    assert match?([1, _second, _third], [1, 2, 3])
  end




MAPS

https://hexdocs.pm/elixir/Map.html
# Maps are the "go to" key-value data structure in Elixir.
# Maps can be created with the %{} syntax, and key-value pairs can be expressed as key => value:

# %{}
# %{}
# %{"one" => :two, 3 => "four"}
# %{3 => "four", "one" => :two}
# Key-value pairs in a map do not follow any order (that's why the printed map in the example above has a different order than the map that was created).

# Maps do not impose any restriction on the key type: anything can be a key in a map. As a key-value structure, maps do not allow duplicated keys. Keys are compared using the exact-equality operator (===/2). If colliding keys are defined in a map literal, the last one prevails.

# When the key in a key-value pair is an atom, the key: value shorthand syntax can be used (as in many other special forms), provided key-value pairs are put at the end:

  koan "Fetching a value returns a tuple with ok when it exists" do
    assert Map.fetch(@person, :age) == {:ok, 27}
  end


  koan "Or you can use some syntactic sugar for existing elements" do
    younger_person = %{@person | age: 16}
    assert Map.fetch(younger_person, :age) == {:ok, 16}
  end

  @person %{
    first_name: "Jon",
    last_name: "Snow",
    age: 27
  }

###############################
MapSets

# MapSets are interesting because it doesnt allow duplicates
# MapSets are actually a hash array mapped trie hwhat?
https://en.wikipedia.org/wiki/Hash_array_mapped_trie
https://en.wikipedia.org/wiki/Trie

# In computer science, a trie, also called digital tree or prefix tree, is a kind of search tree—an ordered tree data structure used to store a dynamic set or associative array where the keys are usually strings. Unlike a binary search tree, no node in the tree stores the key associated with that node; instead, its position in the tree defines the key with which it is associated

  koan "You cannot depend on my order" do
    new_set = MapSet.new(1..33)
    assert sorted?(new_set) == false

    # Note: The number "33" is actually special here. Erlang uses a different
    # implementation for maps after 32 elements which does not maintain order.
    # http://stackoverflow.com/a/40408469

    # What do you think this answer to this assertion is?
    assert sorted?(@set) == ___
  end
  https://stackoverflow.com/questions/38386314/why-elixirs-mapset-becomes-unordered-after-32-elements

# This is not specific to MapSet, but the same thing happens with normal Map (MapSet uses Map under the hood):

iex(1)> for i <- Enum.shuffle(1..32), into: %{}, do: {i, i}
%{1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
  10 => 10, 11 => 11, 12 => 12, 13 => 13, 14 => 14, 15 => 15, 16 => 16,
  17 => 17, 18 => 18, 19 => 19, 20 => 20, 21 => 21, 22 => 22, 23 => 23,
  24 => 24, 25 => 25, 26 => 26, 27 => 27, 28 => 28, 29 => 29, 30 => 30,
  31 => 31, 32 => 32}

iex(2)> for i <- Enum.shuffle(1..33), into: %{}, do: {i, i}
%{11 => 11, 26 => 26, 15 => 15, 20 => 20, 17 => 17, 25 => 25, 13 => 13, 8 => 8,
  7 => 7, 1 => 1, 32 => 32, 3 => 3, 6 => 6, 2 => 2, 33 => 33, 10 => 10, 9 => 9,
  19 => 19, 14 => 14, 5 => 5, 18 => 18, 31 => 31, 22 => 22, 29 => 29, 21 => 21,
  27 => 27, 24 => 24, 30 => 30, 23 => 23, 28 => 28, 16 => 16, 4 => 4, 12 => 12}

# This is because (most likely as an optimization) Erlang stores Maps of size upto MAP_SMALL_MAP_LIMIT as a sorted by key array. Only after the size is greater than MAP_SMALL_MAP_LIMIT Erlang switches to storing the data in a Hash Array Mapped Trie like data structure. In non-debug mode Erlang, MAP_SMALL_MAP_LIMIT is defined to be 32, so all maps with length upto 32 should print in sorted order. Note that this is an implementation detail as far as I know, and you should not rely on this behavior; they may change the value of the constant in the future or switch to a completely different algorithm if it's more performant.


# intersection(map_set, map_set)
# Returns a set containing only members that map_set1 and map_set2 have in common.
  koan "I want only the common values in both sets" do
    intersection_set = MapSet.intersection(@set, MapSet.new([5, 6, 7]))

    assert MapSet.member?(intersection_set, 5) == true
  end



###################################################
Structs
https://inquisitivedeveloper.com/lwm-elixir-18/
https://www.tutorialspoint.com/elixir/elixir_structs.htm

# Structs are extensions built on top of maps that provide compile-time checks and default values.

# A struct is a data structure that stores properties and values. This is similar to an object in C# or a class or struct in C#, except that it only consists of data.

# A struct is actually a specialized map with predefined keys and default values, which functions as a data type. Unlike a map, where any key can be added, a struct can only contain the keys that were predefined at compile time. Any attempt to add a new property results in an error. This results in a data structure that is fixed at compile time.

 koan "Use the put_in macro to replace a nested value" do
    airline = %Airline{plane: %Plane{maker: :boeing}}
    assert put_in(airline.plane.maker, :airbus) == ___
  end

  defmodule Plane do
    defstruct passengers: 0, maker: :boeing
  end

  defmodule Airline do
    defstruct plane: %Plane{}, name: "Southwest"
  end

  koan "Use the put_in macro to replace a nested value" do
    airline = %Airline{plane: %Plane{maker: :boeing}}
    assert put_in(airline.plane.maker, :airbus) == %Airline{ name: "Southwest", plane: %Plane{maker: :airbus, passengers: 0} }

    # assert put_in(airline.plane.maker, :airbus) == %Airline{
    #          name: "Southwest",
    #          plane: %Plane{maker: :airbus, passengers: 0}
    #        }
  end

  koan "Use the put_in macro with atoms to replace a nested value in a non-struct" do
    airline = %{plane: %{maker: :boeing}, name: "Southwest"}

    assert put_in(airline[:plane][:maker], :cessna) == %{
             plane: %{maker: :cessna},
             name: "Southwest"
           }
  end





##########################################################





















































# koan "Is an integer threequal to its float equivalent?" do
#   assert 1 === 1.0 == false
# end

# koan "Revisit division with threequal" do
#   assert 2 / 2 === 1.0
# end

# koan "Another way to divide" do
#   assert div(5, 2) == 2
# end

# koan "The meaning of life in hexadecimal is 2A!" do
#   assert Integer.parse("2A", 16) == {42, ""}
# end

# koan "What if you parse a floating point value as an integer?" do
#   assert Integer.parse("1.2") == {1, ".2"}
# end

# koan "Just want to parse to a float" do
#   assert Float.parse("34.5") == {34.5, ""}
# end

# koan "It is surprising to find out that booleans are atoms" do
#   assert is_atom(true) == true
#   assert is_boolean(false) == true
#   assert true == true
#   assert false == false
# end
