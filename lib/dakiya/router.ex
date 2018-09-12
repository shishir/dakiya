defmodule Dakiya.Router do
  import Dakiya.Mailer
  import Dakiya.Mailgun

  use Plug.Router
  use Plug.ErrorHandler
  plug Plug.Logger, log: :debug

  plug Plug.Parsers, parsers: [:json],
                     json_decoder: Poison
  plug(:match)
  plug(:dispatch)

  post "/create"  do
    res = conn.body_params |> validate |> transform |> merge_defaults |> send_email
    case res do
      {:ok, _} -> send_resp(conn, 200, "Mail queued")
      {:error, data} -> send_resp(conn, 422, Poison.encode!(data))
    end
  end

  match(_, do: send_resp(conn, 404, "Oops!"))

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind)
    IO.inspect(reason)
    IO.inspect(stack)
  end
end