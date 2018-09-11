defmodule Dakiya.Mailgun do
  def send_email(err = {:error, _}), do: err
  def send_email(data) do
    api_key     = System.get_env("MAILGUN_API_KEY")
    domain_name = System.get_env("MAILGUN_DOMAIN_NAME")
    base_url    = "https://api:#{api_key}@api.mailgun.net/v3/#{domain_name}"
    headers     = %{"Content-type" => "application/x-www-form-urlencoded"}
    HTTPoison.post(base_url, URI.encode_query(data), headers)
    # case HTTPoison.post(base_url, URI.encode_query(data), headers) do
    #   {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    #     body
    #   {:ok, %HTTPoison.Response{status_code: 404}} ->
    #     "Not found :("
    #   {:error, %HTTPoison.Error{reason: reason}} ->
    #     reason
    # end
  end
end