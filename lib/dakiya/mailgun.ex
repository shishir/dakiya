defmodule Dakiya.Mailgun do
  def send_email(err = {:error, _}), do: err
  def send_email({:ok, data}) do
    api_key     = System.get_env("MAILGUN_API_KEY")
    domain_name = System.get_env("MAILGUN_DOMAIN_NAME")
    base_url    = "https://api:#{api_key}@api.mailgun.net/v3/#{domain_name}"
    headers     = %{"Content-type" => "application/x-www-form-urlencoded"}

    case HTTPoison.post(base_url, URI.encode_query(data), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:ok, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end