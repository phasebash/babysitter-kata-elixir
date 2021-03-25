defmodule BabysitterTest do
  use ExUnit.Case
  doctest Babysitter

  def subject(start_time, end_time, bed_time) do
    Babysitter.calculate(start_time, end_time, bed_time)
  end

  describe "baby sitter is paid up to bed time" do
    test "can calculate something" do
      assert subject("6:00 PM", "3:00 AM", "9:00 PM") == {:ok, 36}
    end
  end
end
