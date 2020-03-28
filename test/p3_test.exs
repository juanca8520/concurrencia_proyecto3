defmodule P3Test do
  use ExUnit.Case
  doctest P3

  test "greets the world" do
    assert P3.hello() == :world
  end
end
