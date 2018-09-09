defmodule Dakiya do
  alias Dakiya.Mailgun, as: Mailgun

  def main(args) do
    response = args |> parse_args |> transform |> merge_defaults |> Mailgun.send_email
    IO.puts(response)
  end

  def parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [help: :boolean])
    params[:message] |> Poison.decode!
  end

  def transform(data) do
    %{
      to: data["to"],
      subject: data["subject"],
      html: data["body"]
    }
  end

  def merge_defaults(data) do
   Map.merge(%{
      from: "shishir.das@gmail.com"
    }, data)
  end
end
