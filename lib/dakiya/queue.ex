defmodule Dakiya.Queue do
  import Dakiya.Mailgun
  use GenServer
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, [name: :myQueue])
  end

  def enqueue(err = {:error, _}), do: err
  def enqueue({:ok, args}) do
    GenServer.call(:myQueue, {:enqueue, args})
  end

  def init(:ok) do
    schedule_work()
    {:ok, :queue.new}
  end

  def handle_call({:enqueue, args},_from, queue) do
    {:reply, queue,:queue.in(args, queue)}
  end

  def handle_info(:send_mail, queue) do
    case :queue.out(queue) do
      {{:value, head}, queue} ->
        IO.inspect(send_email({:ok, head}))
        schedule_work()
        {:noreply, queue}
      _ ->
        schedule_work()
        {:noreply, queue}
    end
  end

  def handle_info(_msg, queue) do
    {:noreply, queue}
  end

  defp schedule_work() do
    Process.send_after(self(), :send_mail, 2 * 1000)
  end

end