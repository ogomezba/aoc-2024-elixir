defmodule Day13 do
  @button_A_regex ~r/Button A: X\+(\d+), Y\+(\d+)/
  @button_B_regex ~r/Button B: X\+(\d+), Y\+(\d+)/
  @prize_regex ~r/Prize: X=(\d+), Y=(\d+)/

  def process_part_one() do
    "assets/input13.txt"
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(&parse_line/1)
    |> Enum.map(&calculate_coins/1)
    |> Enum.sum()
  end

  def process_part_two() do
    "assets/input13.txt"
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn %{p: {px, py}} = machine ->
      %{machine | p: {px + 10_000_000_000_000, py + 10_000_000_000_000}}
    end)
    |> Enum.map(&calculate_coins/1)
    |> Enum.sum()
  end

  defp calculate_coins(%{p: {px, py}, va: {dax, day}, vb: {dbx, dby}} = machine) do
    a = Nx.tensor([[dax, dbx], [day, dby]], type: {:f, 64})
    p = Nx.tensor([px, py], type: {:f, 64})

    x = Nx.LinAlg.solve(a, p)
    x1 = round(Nx.to_number(x[0]))
    x2 = round(Nx.to_number(x[1]))

    if valid?(x1, x2, machine), do: 3 * x1 + x2, else: 0
  end

  defp valid?(x1, x2, %{p: {px, py}, va: {dax, day}, vb: {dbx, dby}}) do
    x1 * dax + x2 * dbx == px and x1 * day + x2 * dby == py
  end

  defp parse_line(line) do
    [_, dax, day] = Regex.run(@button_A_regex, line)
    [_, dbx, dby] = Regex.run(@button_B_regex, line)
    [_, px, py] = Regex.run(@prize_regex, line)

    %{
      va: {String.to_integer(dax), String.to_integer(day)},
      vb: {String.to_integer(dbx), String.to_integer(dby)},
      p: {String.to_integer(px), String.to_integer(py)}
    }
  end
end
