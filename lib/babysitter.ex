defmodule Babysitter do
  @moduledoc """
  Documentation for `Babysitter`.
  """

  @doc """
  How much do we owe you?

  ## Examples

      iex> Babysitter.calculate("6:00 PM", "5:00 AM", "9:00 PM")
      {:ok, 36}

  """
  def calculate(start_time, end_time, bed_time) do
    with {:ok, s} <- start_time |> WorkTime.parse(),
         {:ok, e} <- end_time |> WorkTime.parse(),
         {:ok, b} <- bed_time |> WorkTime.parse(),
         do: {:ok, calculate_earnings(s, e, b)}
  end

  defp calculate_earnings(start_time, end_time, bed_time) do
    cost = 0

    cost = calculate_evening(start_time, end_time, bed_time) + cost

    cost
  end

  defp calculate_evening(start_time, end_time, bed_time) do
    WorkTime.difference(start_time, bed_time) * 12
  end
end
