defmodule Day6 do
  @up {-1, 0}
  @down {1, 0}
  @left {0, -1}
  @right {0, 1}

  def process_part_one() do
    area =
      "assets/input6.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> add_borders()
      |> transform_to_map()

    a = fn i, j -> area[{i, j}] end

    {initial_cords, _} = Enum.find(area, fn {_cords, value} -> value == "^" end)
    initial_state = {initial_cords, @up}

    visited = navigate(a, initial_state, MapSet.new())
    MapSet.size(visited)
  end

  defp add_borders(area) do
    area = Enum.map(area, &(["O"] ++ &1 ++ ["O"]))
    m = length(hd(area))
    extra_row = List.duplicate("O", m)
    [extra_row] ++ area ++ [extra_row]
  end

  defp transform_to_map(area) do
    m = length(area)
    n = length(hd(area))

    for i <- 0..(m - 1), j <- 0..(n - 1), reduce: %{} do
      result -> Map.put(result, {i, j}, area |> Enum.at(i) |> Enum.at(j))
    end
  end

  defp navigate(a, {{i, j}, dir}, visited) do
    visited = MapSet.put(visited, {i, j})

    case look(a, {i, j}, dir) do
      "#" -> navigate(a, {{i, j}, turn_right(dir)}, visited)
      "O" -> visited
      _ -> navigate(a, {move({i, j}, dir), dir}, visited)
    end
  end

  defp look(a, {i, j}, {di, dj}) do
    a.(i + di, j + dj)
  end

  defp move({i, j}, {di, dj}) do
    {i + di, j + dj}
  end

  defp turn_right(@up), do: @right
  defp turn_right(@right), do: @down
  defp turn_right(@down), do: @left
  defp turn_right(@left), do: @up
end
