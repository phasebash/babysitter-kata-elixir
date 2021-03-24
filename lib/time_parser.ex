defmodule TimeParser do
  @moduledoc """
  Documentation for `TimeParser`.
  """

  @doc """


  ## Examples

      iex> TimeParser.parse("6:00 PM")
      {:ok, [hour: 6, minute: 0, ampm: :PM]}

      iex> TimeParser.parse("13:00 PM")
      {:error, "hour greater than 12"}

  """
  def parse(time) do
    result = Regex.run(~r/(\d?\d):(\d\d) (AM|PM)/, time, capture: :all_but_first)

    case result do
      [_, _, _] -> form_result(result)
      _ -> {:error, "not all fragments provided"}
    end
  end

  defp form_result(pieces) do
    with {:ok, h} <- pieces |> Enum.at(0) |> Integer.parse(10) |> elem(0) |> validate_hour,
         {:ok, m} <- pieces |> Enum.at(1) |> Integer.parse(10) |> elem(0) |> validate_mins,
         {:ok, a} <- pieces |> Enum.at(2) |> String.to_atom() |> validate_ampm,
         do: {:ok, [hour: h, minute: m, ampm: a]}
  end

  defp validate_hour(hour) when hour < 1 do
    {:error, "hour less than 1"}
  end

  defp validate_hour(hour) when hour > 12 do
    {:error, "hour greater than 12"}
  end

  defp validate_hour(hour) do
    {:ok, hour}
  end

  defp validate_mins(mins) when mins < 0 do
    {:error, "minute less than 0"}
  end

  defp validate_mins(mins) when mins > 59 do
    {:error, "minute greater than 59"}
  end

  defp validate_mins(mins) do
    {:ok, mins}
  end

  defp validate_ampm(ampm) do
    {:ok, ampm}
  end
end
