defmodule Dakiya.Mailer do
  def validate(args) do
    acc = validate_presence_of("to", args, [])
    acc = validate_presence_of("body", args, acc, fn(v) -> Map.has_key?(v, "template") end)
    acc = validate_presence_of("subject", args, acc)
    data = if length(acc) == 0 do
      args
    else
      {:error,  acc}
    end
    data
  end

  def validate_presence_of(field, data, acc, skip_if \\ fn(x) -> false end) do
    acc = if ("" == data[field] or nil == data[field]) and !skip_if.(data) do
      acc ++ [{field, "cannot be blank"}]
    else
      acc
    end
    acc
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
    EEx.eval_file "#{__DIR__}/../templates/password-reset.html.eex", [message: message]
  end

  def load_template("welcome", message) do
    EEx.eval_file "#{__DIR__}/../templates/welcome.html.eex", [message: message]
  end

  def merge_defaults(err = {:error, _}), do: err
  def merge_defaults(data) do
   Map.merge(%{
      from: "shishir.das@gmail.com"
    }, data)
  end
end