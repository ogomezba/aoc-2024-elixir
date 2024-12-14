defmodule Day11 do
  require Integer
  use Memoize

  @input "872027 227 18 9760 0 4 67716 9245696"
  @depth 75

  def process() do
    for stone <- String.split(@input), reduce: 0 do
      acc -> acc + count(stone, @depth)
    end
  end

  defmemo(count(_n, 0), do: 1)

  defmemo count(n, depth) do
    for child <- evolve(n), reduce: 0 do
      acc -> acc + count(child, depth - 1)
    end
  end

  defp evolve(stone) do
    m = String.length(stone)

    case {stone, m} do
      {"0", _} ->
        ["1"]

      {stone, m} when Integer.is_even(m) ->
        {left, right} =
          String.split_at(stone, div(m, 2))

        left = left |> String.to_integer() |> Integer.to_string()
        right = right |> String.to_integer() |> Integer.to_string()

        [left, right]

      {stone, _} ->
        [stone |> String.to_integer() |> Kernel.*(2024) |> Integer.to_string()]
    end
  end
end
