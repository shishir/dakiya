defmodule QueueTest do
  use ExUnit.Case, async: true

  # setup do
  #   registry = start_supervised!(Dakiya.Queue)
  # end

  test "gjooara" do
    IO.inspect(Dakiya.Queue.enqueue(%{to: "a@b.com", from: "b@d.com", subject: "mirange", body: "<html>foobar</html>"}))
  end
end