koan "Is an integer threequal to its float equivalent?" do
  assert 1 === 1.0 == false
end

koan "Revisit division with threequal" do
  assert 2 / 2 === 1.0
end

koan "Another way to divide" do
  assert div(5, 2) == 2
end

koan "The meaning of life in hexadecimal is 2A!" do
  assert Integer.parse("2A", 16) == {42, ""}
end

koan "What if you parse a floating point value as an integer?" do
  assert Integer.parse("1.2") == {1, ".2"}
end

koan "Just want to parse to a float" do
  assert Float.parse("34.5") == {34.5, ""}
end

koan "It is surprising to find out that booleans are atoms" do
  assert is_atom(true) == true
  assert is_boolean(false) == true
  assert true == true
  assert false == false
end
