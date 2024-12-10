defmodule Day10 do
  @up {-1, 0}
  @down {1, 0}
  @left {0, -1}
  @right {0, 1}

  def process_part_one() do
    area = get_area()

    area
    |> Map.filter(fn {_coords, value} -> value == 0 end)
    |> Map.keys()
    |> Enum.map(&count_reachable_nines(&1, area))
    |> Enum.sum()
  end

  def process_part_two() do
    area = get_area()

    area
    |> Map.filter(fn {_coords, value} -> value == 0 end)
    |> Map.keys()
    |> Enum.map(&count_distinct_paths(&1, area))
    |> Enum.sum()
  end

  defp get_area() do
    "assets/input10.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> transform_to_map()
  end

  defp transform_to_map(area) do
    m = length(area)
    n = length(hd(area))

    for i <- 0..(m - 1), j <- 0..(n - 1), reduce: %{} do
      result ->
        Map.put(
          result,
          {i, j},
          area
          |> Enum.at(i)
          |> Enum.at(j)
          |> String.to_integer()
        )
    end
  end

  defp count_reachable_nines(coords, area) do
    area
    |> do_calculate_score(coords, -1, MapSet.new(), [])
    |> Enum.uniq()
    |> Enum.count()
  end

  defp count_distinct_paths(coords, area) do
    area
    |> do_calculate_score(coords, -1, MapSet.new(), [])
    |> Enum.count()
  end

  defp do_calculate_score(area, coords, prev, visited, reached_nines) do
    cond do
      MapSet.member?(visited, coords) ->
        reached_nines

      is_nil(area[coords]) ->
        reached_nines

      prev + 1 != area[coords] ->
        reached_nines

      area[coords] == 9 ->
        [coords | reached_nines]

      true ->
        [@up, @right, @down, @left]
        |> Enum.reduce(reached_nines, fn dir, reached_nines ->
          do_calculate_score(
            area,
            move(coords, dir),
            area[coords],
            MapSet.put(visited, coords),
            reached_nines
          )
        end)
    end
  end

  defp move({i, j}, {di, dj}) do
    {i + di, j + dj}
  end
end
