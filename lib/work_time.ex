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
    spans_two_days = start_time.ampm != end_time.ampm && end_time.ampm == :AM
    minutes_worked = canonicalize(end_time, spans_two_days) - canonicalize(start_time)

    hours = div(minutes_worked, 60)
    round_up = if rem(minutes_worked, 60) > 0, do: 1, else: 0

    hours + round_up
  end

  def canonicalize(%WorkTime{} = time, shift \\ false) do
    hour = if shift, do: time.hour + 24, else: time.hour
    minutes = time.minute + hour * 60 + if time.ampm == :PM, do: 12 * 60, else: 0

    if shift do
      minutes
    else
      minutes
    end
  end

  defp form_result([hours, minutes, ampm]) do
    with {:ok, h} <- Integer.parse(hours, 10) |> elem(0) |> validate_hour,
         {:ok, m} <- Integer.parse(minutes, 10) |> elem(0) |> validate_mins,
         {:ok, a} <- ampm |> String.to_atom() |> validate_ampm,
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
