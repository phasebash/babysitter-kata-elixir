defmodule BabysitterTest do
  use ExUnit.Case
  doctest Babysitter

  test "can calculate something" do
    assert Babysitter.calculate('6:00 PM', '3:00AM')
  end
end
