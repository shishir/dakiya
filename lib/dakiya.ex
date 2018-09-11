defmodule Dakiya do
  alias Dakiya.Mailgun, as: Mailgun

  def main(args) do
    response = args |> parse_args |> validate |> transform |> merge_defaults |> Mailgun.send_email
    IO.inspect(response)
  end

  def validate(args) do
    acc = validate_presence_of("to", args, [])
    acc = validate_presence_of("body", args, acc, fn(v) -> Map.has_key?(v, "template") end)
    acc = validate_presence_of("subject", args, acc)
    if length(acc) == 0 do
      args
    else
      {:error,  acc}
    end
  end

  def validate_presence_of(field, data, acc, skip_if \\ fn(x) -> false end) do
    acc = if ("" == data[field] or nil == data[field]) and !skip_if.(data) do
      acc ++ [{field, "cannot be blank"}]
    else
      acc
    end
    acc
  end

  def parse_args(err = {:error, _}), do: err
  def parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [help: :boolean])
    params[:message] |> Poison.decode!
  end

  def transform(err = {:error, _}), do: err
  def transform(data) do
    html = if data["body"] do
            data["body"]
           else
            load_template(data["template"]["name"], data["template"]["message"])
           end
    %{
      to: data["to"],
      subject: data["subject"],
      html: html
    }
  end

  def load_template("password-reset", message) do
    "<html>Password Reset</html>"
  end

  def load_template("welcome", message) do
    "<html>Welcome</html>"
  end

  def merge_defaults(err = {:error, _}), do: err
  def merge_defaults(data) do
   Map.merge(%{
      from: "shishir.das@gmail.com"
    }, data)
  end
end
