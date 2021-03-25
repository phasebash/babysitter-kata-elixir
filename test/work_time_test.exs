defmodule WorkTimeTest do
  use ExUnit.Case
  doctest WorkTime

  def subject(value) do
    WorkTime.parse(value)
  end

  def difference(s, e) do
    with {:ok, s} <- WorkTime.parse(s),
         {:ok, e} <- WorkTime.parse(e),
         do: WorkTime.difference(s, e)
  end

  describe "valid times" do
    test "parser a date in the PMs" do
      assert subject("5:00 PM") == {:ok, %WorkTime{hour: 5, minute: 0, ampm: :PM}}
    end

    test "parser a date in the AMs" do
      assert subject("12:59 AM") == {:ok, %WorkTime{hour: 12, minute: 59, ampm: :AM}}
    end
  end

  describe "invalid times" do
    test "fails to parse when pieces are missing" do
      assert subject("12:59") == {:error, "not all fragments provided"}
    end

    test "fails to validate hour is greater than 12" do
      assert subject("13:59 AM") == {:error, "hour greater than 12"}
    end

    test "fails to validate minute when greater than 59" do
      assert subject("12:60 AM") == {:error, "minute greater than 59"}
    end

    test "fails to validate minute less than 0" do
      assert subject("12:-10 AM") == {:error, "not all fragments provided"}
    end
  end

  describe "difference" do
    test "can make the difference between two AM times" do
      assert difference("4:00 AM", "6:00 AM") == 2
    end

    test "can make the difference between two PM times" do
      assert difference("4:00 PM", "6:00 PM") == 2
    end

    test "can make the difference between an AM and PM" do
      assert difference("4:00 AM", "6:00 PM") == 14
    end

    test "can make the difference between an PM and AM" do
      assert difference("4:00 PM", "6:00 AM") == 14
    end
  end
end
