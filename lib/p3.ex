defmodule P3 do
  use CSP

  def start_lottery(winner_number, number_of_calls) do
    count_channel = Channel.new()
    tel_1 = Channel.new(buffer_size: number_of_calls, buffer_type: :sliding)
    tel_2 = Channel.new(buffer_size: number_of_calls, buffer_type: :sliding)
    tel_3 = Channel.new(buffer_size: number_of_calls, buffer_type: :sliding)
    tel_4 = Channel.new(buffer_size: number_of_calls, buffer_type: :sliding)

    spawn(fn -> count(count_channel, 1, winner_number) end)
    spawn(fn -> waiting_for_messages(tel_1, count_channel) end)
    spawn(fn -> waiting_for_messages(tel_2, count_channel) end)
    spawn(fn -> waiting_for_messages(tel_3, count_channel) end)
    spawn(fn -> waiting_for_messages(tel_4, count_channel) end)

    generate_calls(tel_1, tel_2, tel_3, tel_4, 1, number_of_calls)
  end

  def waiting_for_messages(channel, count_channel) do
    caller_id = Channel.get(channel)
    Channel.put(count_channel, caller_id)
    Process.sleep(:rand.uniform(1500))
    waiting_for_messages(channel, count_channel)
  end

  def count(channel, number_of_calls, winner_number) do
    caller_id = Channel.get(channel)

    if number_of_calls == winner_number do
      IO.puts("Winner: caller id #{caller_id} with number of call #{number_of_calls}")
    else
      IO.puts("Keep trying: caller id #{caller_id} with number of call #{number_of_calls}")
    end

    count(channel, number_of_calls + 1, winner_number)
  end

  def generate_calls(c1, c2, c3, c4, id, number_of_calls) when id == number_of_calls do
    random_number = :rand.uniform(4)

    case random_number do
      1 ->
        spawn(fn -> Channel.put(c1, id) end)

      2 ->
        spawn(fn -> Channel.put(c2, id) end)

      3 ->
        spawn(fn -> Channel.put(c3, id) end)

      4 ->
        spawn(fn -> Channel.put(c4, id) end)
    end
  end

  def generate_calls(c1, c2, c3, c4, id, number_of_calls) when id < number_of_calls do
    random_number = :rand.uniform(4)

    case random_number do
      1 ->
        spawn(fn -> Channel.put(c1, id) end)

      2 ->
        spawn(fn -> Channel.put(c2, id) end)

      3 ->
        spawn(fn -> Channel.put(c3, id) end)

      4 ->
        spawn(fn -> Channel.put(c4, id) end)
    end
    generate_calls(c1, c2, c3, c4, id + 1, number_of_calls)
  end
end
