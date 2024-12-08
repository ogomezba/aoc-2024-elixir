defmodule Day8 do
  def process_part_one() do
    area = get_area()
    m = length(area)
    n = length(hd(area))

    out_of_bounds? = fn {x, y} -> x < 0 or x > m - 1 or y < 0 or y > n - 1 end

    area
    |> get_antennas_coordinates(m, n)
    |> Enum.flat_map(&get_antinodes(&1))
    |> Enum.uniq()
    |> Enum.reject(out_of_bounds?)
    |> Enum.count()
  end

  def process_part_two() do
    area = get_area()
    m = length(area)
    n = length(hd(area))

    area
    |> get_antennas_coordinates(m, n)
    |> Enum.flat_map(&get_antinodes_with_resonance(&1, m, n))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp get_area() do
    "assets/input8.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp get_antennas_coordinates(area, m, n) do
    for i <- 0..(m - 1),
        j <- 0..(n - 1),
        antenna = Enum.at(Enum.at(area, i), j),
        antenna != "." do
      {antenna, {i, j}}
    end
    |> Enum.group_by(fn {antenna, _coords} -> antenna end, fn {_a, coords} -> coords end)
    |> Map.values()
  end

  defp get_antinodes([]), do: []

  defp get_antinodes([{x1, y1} | rest]) do
    antinodes =
      for {x2, y2} <- rest, {vx, vy} = {x2 - x1, y2 - y1} do
        [{x2 + vx, y2 + vy}, {x1 - vx, y1 - vy}]
      end
      |> List.flatten()

    antinodes ++ get_antinodes(rest)
  end

  defp get_antinodes_with_resonance([], _m, _n), do: []

  defp get_antinodes_with_resonance([{x1, y1} | rest], m, n) do
    antinodes =
      for {x2, y2} <- rest, {vx, vy} = {x2 - x1, y2 - y1} do
        follow_line({x1 + vx, y1 + vy}, {vx, vy}, [{x1, y1}], m, n) ++
          follow_line({x1 - vx, y1 - vy}, {-vx, -vy}, [{x1, y1}], m, n)
      end
      |> List.flatten()

    antinodes ++ get_antinodes_with_resonance(rest, m, n)
  end

  defp follow_line({x, y}, {vx, vy} = v, antinodes, m, n) do
    if x < 0 or x > m - 1 or y < 0 or y > n - 1 do
      antinodes
    else
      follow_line({x + vx, y + vy}, v, [{x, y} | antinodes], m, n)
    end
  end
end
