defmodule Day3 do
  def process_part_one() do
    pattern = ~r/mul\((\d{1,3}),(\d{1,3})\)/
    input = File.read!("assets/input3.txt")

    pattern
    |> Regex.scan(input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  defp calculate([], total, _), do: total

  defp calculate(matches, total, true) do
    case matches do
      [["don't()"] | rest] ->
        calculate(rest, total, false)

      [[_, a, b] | rest] ->
        a = String.to_integer(a)
        b = String.to_integer(b)

        calculate(rest, total + a * b, true)

      [_ | rest] ->
        calculate(rest, total, true)
    end
  end

  defp calculate(matches, total, false) do
    case matches do
      [["do()"] | rest] -> calculate(rest, total, true)
      [_ | rest] -> calculate(rest, total, false)
    end
  end

  def process_part_two() do
    pattern = ~r/(?:do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\))/
    input = File.read!("assets/input3.txt")

    pattern
    |> Regex.scan(input)
    |> calculate(0, true)
  end
end
