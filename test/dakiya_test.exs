defmodule DakiyaTest do
  use ExUnit.Case, async: true

  import Dakiya.Mailgun
  import Dakiya.Mailer
  import Cli

  test "parses message out" do
    args = ["--message={\"to\": \"shishir.das@gmail.com\", \"subject\":  \"Example Email\", \"body\":  \"<html>foobar</html>\"}"]
    expected = %{
              "body" => "<html>foobar</html>",
              "subject" => "Example Email",
              "to" => "shishir.das@gmail.com"
    }
    assert expected == parse_args(args)
  end

  test "transform input to mailgun accepted format" do
    expected = %{
      to: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html>foobar</html>",
    }

    assert {:ok, expected} == transform({:ok, %{
              "body" => "<html>foobar</html>",
              "subject" => "Example Email",
              "to" => "shishir.das@gmail.com"
            }})
  end

  test "merge default parameters with passed in data" do
    expected = %{
      to: "shishir.das@gmail.com",
      from: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html>foobar</html>",
    }

    assert {:ok, expected} == merge_defaults({:ok, %{
      to: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html>foobar</html>",
    }})
  end

  test "validate user passed data" do
    args = %{
      "body" => "",
      "subject" => "",
      "to" => ""
    }
    assert {:error, [%{"to" => "cannot be blank"},%{"body" => "cannot be blank"},%{"subject" => "cannot be blank"}]} == validate(args)
  end

  test "validate if template is passed, body is optional and vica versa" do
    args = %{
      "to" => "a@b.com",
      "subject" => "foobar",
      "template" => "password-reset"
    }
    assert {:ok, args} == validate(args)
  end

  test "transform should load template if body is not present" do
    args = %{
      "to" => "shishir.das@gmail.com",
      "subject" => "Example Email",
      "template" => %{"name" => "password-reset", "message" => "Done!"}
    }

    expected = %{
      to: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html><body>Password Reset,Done!</body></html>",
    }

    assert {:ok, expected} == transform({:ok, args})
  end

  test "transform should load welcome-email template" do
    args = %{
      "to" => "shishir.das@gmail.com",
      "subject" => "Example Email",
      "template" => %{"name" => "welcome", "message" => "Fabulous"}
    }

    expected = %{
      to: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html><body>Welcome, Fabulous</body></html>",
    }

    assert {:ok, expected} == transform({:ok, args})
  end

  test "send mail should return validation error" do
    assert {:error, [:foo]} == parse_args( {:error, [:foo]})
    assert {:error, [:foo]} == merge_defaults( {:error, [:foo]})
    assert {:error, [:foo]} == transform( {:error, [:foo]})
    assert {:error, [:foo]} == send_email( {:error, [:foo]})
  end
end