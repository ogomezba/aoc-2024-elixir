defmodule Day5 do
  def process_part_one() do
    {rules, pages} =
      "assets/input5.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.split(1176)

    rules =
      Enum.map(rules, fn line ->
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

    manual = Enum.group_by(rules, fn {_, b} -> b end, fn {a, _} -> a end)

    pages
    |> Enum.filter(&is_valid?(&1, manual))
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end

  def process_part_two() do
    {manual, rows} =
      "assets/input5.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.split(1176)

    rules_list =
      Enum.map(manual, fn line ->
        [a, b] = String.split(line, "|", trim: true)
        [String.to_integer(a), String.to_integer(b)]
      end)

    rules_map = Enum.group_by(rules_list, fn [_, b] -> b end, fn [a, _] -> a end)

    rows
    |> Enum.map(fn row ->
      row
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reject(&is_valid?(&1, rules_map))
    |> Enum.map(&sort_with_rules(&1, rules_map))
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end

  defp is_valid?([], _), do: true

  defp is_valid?([base | rest], manual) do
    should_be_before = manual[base] || []
    if Enum.any?(rest, &(&1 in should_be_before)), do: false, else: is_valid?(rest, manual)
  end

  defp get_middle(page) do
    middle_index = div(length(page), 2)
    Enum.at(page, middle_index)
  end

  defp sort_with_rules(row, rules) do
    Enum.sort(row, fn a, b ->
      after_elements = rules[a] || []
      b in after_elements
    end)
  end
end
