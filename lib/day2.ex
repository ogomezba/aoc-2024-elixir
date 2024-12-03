defmodule Day2 do
  defp do_is_safe([_last], _), do: true

  defp do_is_safe([current, next | rest], ascending) do
    diff = abs(current - next)

    cond do
      next > current != ascending -> false
      diff < 1 || diff > 3 -> false
      true -> do_is_safe([next | rest], ascending)
    end
  end

  defp is_safe([]), do: true
  defp is_safe([_]), do: true
  defp is_safe([current, next | _] = items), do: do_is_safe(items, next > current)

  defp do_is_safe_with_tolerance([_last], _), do: true

  defp do_is_safe_with_tolerance([current, next | rest], ascending) do
    diff = abs(current - next)

    cond do
      next > current != ascending -> do_is_safe([current | rest], ascending)
      diff < 1 || diff > 3 -> do_is_safe([current | rest], ascending)
      true -> do_is_safe_with_tolerance([next | rest], ascending)
    end
  end

  defp is_safe_with_tolerance(numbers) when length(numbers) < 3, do: true

  defp is_safe_with_tolerance([prev, current, next | rest] = items) do
    do_is_safe_with_tolerance(items, current > prev) or
      do_is_safe([prev, next | rest], next > prev) or
      do_is_safe([current, next | rest], next > current)
  end

  defp get_input_lines(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.split() |> Enum.map(fn n -> String.to_integer(n) end)))
  end

  def process_part_one() do
    "assets/input2.txt"
    |> get_input_lines()
    |> Enum.filter(&is_safe/1)
    |> length()
  end

  def process_part_two() do
    "assets/input2.txt"
    |> get_input_lines()
    |> Enum.filter(&is_safe_with_tolerance/1)
    |> length()
  end
end
