defmodule DakiyaTest do
  use ExUnit.Case
  doctest Dakiya

  test "greets the world" do
    assert Dakiya.hello() == :world
  end
end
