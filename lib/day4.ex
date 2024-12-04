defmodule Day4 do
  defp count("", count), do: count

  defp count(s, count) do
    rest = binary_part(s, 1, byte_size(s) - 1)

    case s do
      "XMAS" <> _ -> count(rest, count + 1)
      "SAMX" <> _ -> count(rest, count + 1)
      _ -> count(rest, count)
    end
  end

  defp rows(input) do
    String.split(input, "\n", trim: true)
  end

  defp cols(rows) do
    n = rows |> hd() |> String.split("", trim: true) |> length()

    0..(n - 1)
    |> Enum.map(fn i ->
      Enum.join(Enum.map(rows, fn row -> Enum.at(String.split(row, "", trim: true), i) end))
    end)
  end

  defp diagonals(rows) do
    diagonals_down = Enum.map(diagonals_down(rows), &Enum.join(&1))
    diagonals_up = Enum.map(diagonals_up(rows), &Enum.join(&1))

    diagonals_down ++ diagonals_up
  end

  defp diagonals_down(matrix) do
    m = length(matrix)

    for offset <- -(m - 1)..(m - 1), reduce: [] do
      acc ->
        diagonal =
          for row <- 0..(m - 1),
              col = row + offset,
              col >= 0 and col < m,
              do: Enum.at(matrix, row) |> Enum.at(col)

        if diagonal == [], do: acc, else: [diagonal | acc]
    end
    |> Enum.reverse()
  end

  defp diagonals_up(matrix) do
    rows = length(matrix)
    cols = length(List.first(matrix))

    for offset <- 0..(rows + cols - 2), reduce: [] do
      acc ->
        diagonal =
          for row <- 0..(rows - 1),
              col = offset - row,
              col >= 0 and col < cols,
              do: Enum.at(matrix, row) |> Enum.at(col)

        if diagonal == [], do: acc, else: [diagonal | acc]
    end
    |> Enum.reverse()
  end

  defp valid?(submatrix) do
    case(submatrix) do
      [
        ["M", _, "M"],
        [_, "A", _],
        ["S", _, "S"]
      ] ->
        true

      [
        ["M", _, "S"],
        [_, "A", _],
        ["M", _, "S"]
      ] ->
        true

      [
        ["S", _, "M"],
        [_, "A", _],
        ["S", _, "M"]
      ] ->
        true

      [
        ["S", _, "S"],
        [_, "A", _],
        ["M", _, "M"]
      ] ->
        true

      _ ->
        false
    end
  end

  def process_part_two() do
    matrix =
      "assets/input4.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    n = length(matrix)
    a = fn row, col -> Enum.at(Enum.at(matrix, row), col) end

    for i <- 0..(n - 3), j <- 0..(n - 3), reduce: 0 do
      count ->
        submatrix = [
          [a.(i, j), a.(i, j + 1), a.(i, j + 2)],
          [a.(i + 1, j), a.(i + 1, j + 1), a.(i + 1, j + 2)],
          [a.(i + 2, j), a.(i + 2, j + 1), a.(i + 2, j + 2)]
        ]

        if valid?(submatrix), do: count + 1, else: count
    end
  end

  def process_part_one() do
    input = File.read!("assets/input4.txt")

    rows = rows(input)
    cols = cols(rows)
    diagonals = diagonals(Enum.map(rows, &String.split(&1, "", trim: true)))
    candidates = rows ++ cols ++ diagonals

    for candidate <- candidates, reduce: 0 do
      count -> count + count(candidate, 0)
    end
  end
end
