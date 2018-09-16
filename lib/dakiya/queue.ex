defmodule Dakiya.Queue do
  use GenServer
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, [name: :myQueue])
  end

  def enqueue(args) do
    GenServer.call(:myQueue, {:enqueue, args})
  end

  def dequeue(args) do
    GenServer.call(:myQueue, {:dequeue, args})
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:enqueue, args},_from, state) do
    {:reply, state ++ [args], state}
  end

  def handle_info(:send_mail, state) do
    IO.puts(">>>>>>>>>>>>>>. working")
    schedule_work()
    {:noreply, state}
  end
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :send_mail, 2 * 1000)
  end

end