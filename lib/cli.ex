defmodule Cli do
  import Dakiya.Mailgun
  import Dakiya.Mailer

  def main(args) do
    response = args |> parse_args |> validate |> transform |> merge_defaults |> send_email
    IO.inspect(response)
  end

  def parse_args(err = {:error, _}), do: err
  def parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [help: :boolean])
    params[:message] |> Poison.decode!
  end
end