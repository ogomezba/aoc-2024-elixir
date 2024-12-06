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

    {initial_coords, _} = Enum.find(area, fn {_coords, value} -> value == "^" end)
    initial_state = {initial_coords, @up}

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

  defp navigate(a, {coords, dir}, visited) do
    visited = MapSet.put(visited, coords)

    case look(a, coords, dir) do
      "#" -> navigate(a, {coords, turn_right(dir)}, visited)
      "O" -> visited
      _ -> navigate(a, {move(coords, dir), dir}, visited)
    end
  end

  def process_part_two() do
    area =
      "assets/input6.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> add_borders()
      |> transform_to_map()

    {initial_coords, _} = Enum.find(area, fn {_coords, value} -> value == "^" end)
    initial_state = {initial_coords, @up}

    count_potential_loops(initial_state, area)
  end

  defp count_potential_loops(initial_state, area) do
    candidate_obstacle_coords =
      area
      |> Map.filter(fn {_coords, value} -> value == "." end)
      |> Map.keys()

    candidate_obstacle_coords
    |> Enum.filter(&is_loop?(area, &1, initial_state))
    |> Enum.count()
  end

  defp is_loop?(area, obstacle_coords, initial_state) do
    candidate_area = Map.put(area, obstacle_coords, "#")
    a = fn i, j -> candidate_area[{i, j}] end
    do_is_loop?(a, initial_state, MapSet.new())
  end

  defp do_is_loop?(a, {coords, dir} = state, visited) do
    if MapSet.member?(visited, state) do
      true
    else
      visited = MapSet.put(visited, state)

      case look(a, coords, dir) do
        "#" -> do_is_loop?(a, {coords, turn_right(dir)}, visited)
        "O" -> false
        _ -> do_is_loop?(a, {move(coords, dir), dir}, visited)
      end
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
