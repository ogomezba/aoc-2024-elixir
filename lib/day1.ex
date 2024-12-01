defmodule Day1 do
  def process_part_one() do
    "assets/input1.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line)
      {String.to_integer(a), String.to_integer(b)}
    end)
    |> Enum.unzip()
    |> then(fn {left, right} -> [Enum.sort(left), Enum.sort(right)] end)
    |> Enum.zip()
    |> Enum.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  def process_part_two() do
    {left, right} =
      "assets/input1.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [a, b] = String.split(line)
        {String.to_integer(a), String.to_integer(b)}
      end)
      |> Enum.unzip()

    frequencies = Enum.group_by(right, & &1)

    left
    |> Enum.map(&(&1 * length(Map.get(frequencies, &1, []))))
    |> Enum.sum()
  end
end
