defmodule WorkTime do
  @moduledoc """
  Documentation for `WorkTime`.
  """

  @doc """


  ## Examples

      iex> WorkTime.parse("6:00 PM")
      {:ok, %WorkTime{hour: 6, minute: 0, ampm: :PM}}

      iex> WorkTime.parse("13:00 PM")
      {:error, "hour greater than 12"}

  """

  defstruct hour: nil,
            minute: nil,
            ampm: nil

  def parse(time) do
    result = Regex.run(~r/(\d?\d):(\d\d) (AM|PM)/, time, capture: :all_but_first)

    case result do
      [_, _, _] -> form_result(result)
      _ -> {:error, "not all fragments provided"}
    end
  end

  def difference(%WorkTime{} = start_time, %WorkTime{} = end_time) do
    diff = end_time.hour - start_time.hour

    if start_time.ampm != end_time.ampm do
      diff + 12
    else
      diff
    end
  end

  defp form_result(pieces) do
    with {:ok, h} <- pieces |> Enum.at(0) |> Integer.parse(10) |> elem(0) |> validate_hour,
         {:ok, m} <- pieces |> Enum.at(1) |> Integer.parse(10) |> elem(0) |> validate_mins,
         {:ok, a} <- pieces |> Enum.at(2) |> String.to_atom() |> validate_ampm,
         do: {:ok, %WorkTime{hour: h, minute: m, ampm: a}}
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
