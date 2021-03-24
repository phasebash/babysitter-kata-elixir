defmodule TimeParserTest do
  use ExUnit.Case
  doctest TimeParser

  def subject(value) do
    TimeParser.parse(value)
  end

  describe "valid times" do
    test "parser a date in the PMs" do
      assert subject("5:00 PM") == {:ok, hour: 5, minute: 0, ampm: :PM}
    end

    test "parser a date in the AMs" do
      assert subject("12:59 AM") == {:ok, hour: 12, minute: 59, ampm: :AM}
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
end
