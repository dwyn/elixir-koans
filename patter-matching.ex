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
