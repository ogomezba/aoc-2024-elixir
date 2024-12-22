defmodule Day19 do
  use Memoize

  def process_part_one() do
    input = File.read!("assets/input19.txt")

    [towels, patterns] = String.split(input, "\n\n")
    towels = String.split(towels, ", ", trim: true)

    patterns
    |> String.split("\n", trim: true)
    |> Enum.filter(&valid?(&1, towels))
    |> Enum.count()
  end

  def process_part_two() do
    input = File.read!("assets/input19.txt")

    [towels, patterns] = String.split(input, "\n\n")
    towels = String.split(towels, ", ", trim: true)

    patterns
    |> String.split("\n", trim: true)
    |> Enum.map(&count_options(&1, towels))
    |> Enum.sum()
  end

  defmemop(count_options("", _towels), do: 1)

  defmemop count_options(pattern, towels) do
    Enum.reduce(towels, 0, fn towel, acc ->
      case pattern do
        ^towel <> rest -> acc + count_options(rest, towels)
        _ -> acc
      end
    end)
  end

  defp valid?("", _towels), do: true

  defp valid?(pattern, towels) do
    Enum.any?(towels, fn towel ->
      case pattern do
        ^towel <> rest -> valid?(rest, towels)
        _ -> false
      end
    end)
  end
end
