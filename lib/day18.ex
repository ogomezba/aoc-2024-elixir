defmodule Day18 do
  @m 70

  @up {-1, 0}
  @down {1, 0}
  @left {0, -1}
  @right {0, 1}

  def process_part_one() do
    area = get_area()
    input = File.read!("assets/input18.txt")

    area =
      for line <- String.split(input, "\n", trim: true) |> Enum.take(1024),
          [x, y] = String.split(line, ",", trim: true),
          coords = {String.to_integer(x), String.to_integer(y)},
          reduce: area do
        area -> Map.put(area, coords, "#")
      end

    find_shortest_path(area)
  end

  def process_part_two() do
    area = get_area()
    input = File.read!("assets/input18.txt")

    areas =
      for line <- String.split(input, "\n", trim: true),
          [x, y] = String.split(line, ",", trim: true),
          coords = {String.to_integer(x), String.to_integer(y)},
          reduce: [{false, area}] do
        [{_, last} | _] = areas -> [{coords, Map.put(last, coords, "#")} | areas]
      end
      |> Enum.reverse()

    {coords, _} =
      Enum.find(areas, fn {_coords, area} ->
        find_shortest_path(area) == true
      end)

    IO.inspect(coords)
  end

  defp find_shortest_path(area) do
    bfs(area, [{0, 0}], MapSet.new(), 0)
  end

  defp bfs(area, queue, visited, lvl) do
    result =
      Enum.reduce_while(queue, {false, visited, []}, fn coords, {_, visited, next_queue} ->
        case coords do
          {@m, @m} ->
            {:halt, {true, MapSet.put(visited, coords), []}}

          coords ->
            visited = MapSet.put(visited, coords)

            next =
              for dir <- [@up, @right, @down, @left],
                  coords = move(coords, dir),
                  tile = area[coords],
                  tile not in ["#", nil],
                  not MapSet.member?(visited, coords),
                  coords not in next_queue do
                coords
              end

            {:cont, {false, visited, next ++ next_queue}}
        end
      end)

    case result do
      {false, _visited, []} ->
        true

      {true, _visited, _new_queue} ->
        lvl

      {false, visited, new_queue} ->
        bfs(area, new_queue, visited, lvl + 1)
    end
  end

  defp move({i, j}, {di, dj}) do
    {i + di, j + dj}
  end

  defp get_area() do
    for x <- 0..@m, y <- 0..@m, reduce: %{} do
      area -> Map.put(area, {x, y}, ".")
    end
  end
end
