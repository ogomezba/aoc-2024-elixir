defmodule Day5 do
  defp is_valid?([], _), do: true

  defp is_valid?([base | rest], manual) do
    should_be_before = manual[base] || []
    if Enum.any?(rest, &(&1 in should_be_before)), do: false, else: is_valid?(rest, manual)
  end

  defp get_middle(page) do
    middle_index = div(length(page), 2)
    Enum.at(page, middle_index)
  end

  def process_part_one() do
    {manual, pages} =
      "assets/input5.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.split(1176)

    manual =
      Enum.map(manual, fn line ->
        [a, b] = String.split(line, "|", trim: true)
        {String.to_integer(a), String.to_integer(b)}
      end)

    pages =
      pages
      |> Enum.map(fn row ->
        row
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    manual = Enum.group_by(manual, fn {_, b} -> b end, fn {a, _} -> a end)

    pages
    |> Enum.filter(&is_valid?(&1, manual))
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end
end
