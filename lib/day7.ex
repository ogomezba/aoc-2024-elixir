defmodule Day7 do
  def process_part_one() do
    parse_input()
    |> Enum.filter(fn input -> is_valid_with?(input, [&+/2, &*/2]) end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum()
  end

  def process_part_two() do
    parse_input()
    |> Enum.filter(fn input -> is_valid_with?(input, [&+/2, &*/2, &concat/2]) end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum()
  end

  defp parse_input() do
    "assets/input7.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [result, operands] = String.split(line, ":")
      operands = operands |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      {String.to_integer(result), operands}
    end)
  end

  defp concat(a, b) do
    "#{a}#{b}" |> String.to_integer()
  end

  defp is_valid_with?({result, [initial | rest]}, operators) do
    do_is_valid(result, initial, rest, operators)
  end

  defp do_is_valid(result, acc, [], _), do: result == acc

  defp do_is_valid(result, acc, [current | rest], operators) do
    operators
    |> Enum.reduce_while(false, fn operator, _ ->
      if do_is_valid(result, operator.(acc, current), rest, operators),
        do: {:halt, true},
        else: {:cont, false}
    end)
  end
end
