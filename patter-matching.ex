def make_noise(%{type: "cat"}), do: "Meow"
def make_noise(%{type: "dog"}), do: "Woof"
def make_noise(_anything), do: "Eh?"

koan "Functions perform pattern matching on their arguments" do
  cat = %{type: "cat"}
  dog = %{type: "dog"}
  snake = %{type: "snake"}

  assert make_noise(cat) == "Meow"
  assert make_noise(dog) == "Woof"
  assert make_noise(snake) == "Eh?"
end


+++++++++++++++++++++++++++++++++


  koan "A variable can be pinned to use its value when matching instead of binding to a new value" do
    pinned_variable = 1

    example = fn
      ^pinned_variable -> "The number One"
      2 -> "The number Two"
      number -> "The number #{number}"
    end

    assert example.(1) == "The number One"
    assert example.(2) == "The number Two"
    assert example.(3) == "The number 3"
  end
