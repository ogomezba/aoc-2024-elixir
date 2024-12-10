defmodule Day9 do
  def process_part_one() do
    parse_input()
    |> List.flatten()
    |> Enum.reverse()
    |> compress()
    |> calculate_checksum()
  end

  def process_part_two() do
    parse_input()
    |> compress_files()
    |> Enum.reverse()
    |> List.flatten()
    |> calculate_checksum()
  end

  defp parse_input() do
    "assets/input9.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> generate_blocks()
  end

  defp generate_blocks(input) do
    {_, _, blocks} =
      for frequency <- input, reduce: {true, 0, []} do
        {false, idx, acc} ->
          if frequency != 0,
            do: {true, idx, [List.duplicate(".", frequency) | acc]},
            else: {true, idx, acc}

        {true, idx, acc} ->
          {false, idx + 1, [List.duplicate(idx, frequency) | acc]}
      end

    blocks
  end

  defp compress(input) do
    do_compress(input, [], 0, length(input) - 1)
  end

  defp do_compress(_input, acc, i, j) when i > j, do: Enum.reverse(acc)

  defp do_compress(input, acc, i, j) do
    case Enum.at(input, i) do
      "." ->
        {n, j} = get_next_number_from_end(input, j)
        if i > j, do: Enum.reverse(acc), else: do_compress(input, [n | acc], i + 1, j)

      n ->
        do_compress(input, [n | acc], i + 1, j)
    end
  end

  defp get_next_number_from_end(input, j) do
    case Enum.at(input, j) do
      "." -> get_next_number_from_end(input, j - 1)
      n -> {n, j - 1}
    end
  end

  defp compress_files([]), do: []

  defp compress_files([file | rest]) do
    case hd(file) do
      "." ->
        file ++ compress_files(rest)

      _ ->
        {updated_rest, changed?} =
          maybe_move_to_empty(rest, file)

        if changed?,
          do: [List.duplicate(".", length(file)) | compress_files(updated_rest)],
          else: [file | compress_files(updated_rest)]
    end
  end

  defp maybe_move_to_empty([], _), do: {[], false}

  defp maybe_move_to_empty([current | rest], file) do
    {updated_rest, changed?} = maybe_move_to_empty(rest, file)
    file_length = length(file)
    current_length = length(current)

    if changed? or hd(current) != "." or current_length < file_length do
      {[current | updated_rest], changed?}
    else
      case current_length - file_length do
        0 -> {[file | updated_rest], true}
        n -> {[List.duplicate(".", n), file] ++ updated_rest, true}
      end
    end
  end

  defp calculate_checksum(input) do
    for {n, i} <- Enum.with_index(input), n !== ".", reduce: 0 do
      acc -> acc + i * n
    end
  end
end
