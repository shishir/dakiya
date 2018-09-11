defmodule DakiyaTest do
  use ExUnit.Case
  doctest Dakiya

  test "parses message out" do
    args = ["--message={\"to\": \"shishir.das@gmail.com\", \"subject\":  \"Example Email\", \"body\":  \"<html>foobar</html>\"}"]
    expected = %{
              "body" => "<html>foobar</html>",
              "subject" => "Example Email",
              "to" => "shishir.das@gmail.com"
    }
    assert expected == Dakiya.parse_args(args)
  end

  test "transform input to mailgun accepted format" do
    expected = %{
      to: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html>foobar</html>",
    }

    assert expected == Dakiya.transform(%{
              "body" => "<html>foobar</html>",
              "subject" => "Example Email",
              "to" => "shishir.das@gmail.com"
            })
  end

  test "merge default parameters with passed in data" do
    expected = %{
      to: "shishir.das@gmail.com",
      from: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html>foobar</html>",
    }

    assert expected == Dakiya.merge_defaults(%{
      to: "shishir.das@gmail.com",
      subject: "Example Email",
      html: "<html>foobar</html>",
    })
  end

  test "validate user passed data" do
    args = %{
      "body" => "",
      "subject" => "",
      "to" => ""
    }
    assert {:error, [{"to", "cannot be blank"},{"body", "cannot be blank"},{"subject", "cannot be blank"}]} == Dakiya.validate(args)
  end

  test "validate if template is passed, body is optional and vica versa" do
    args = %{
      "to" => "a@b.com",
      "subject" => "foobar",
      "template" => "password-reset"
    }
    assert args == Dakiya.validate(args)
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

    assert expected == Dakiya.transform(args)
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

    assert expected == Dakiya.transform(args)
  end

  test "send mail should return validation error" do
    assert {:error, [:foo]} == Dakiya.parse_args( {:error, [:foo]})
    assert {:error, [:foo]} == Dakiya.merge_defaults( {:error, [:foo]})
    assert {:error, [:foo]} == Dakiya.transform( {:error, [:foo]})
    assert {:error, [:foo]} == Dakiya.Mailgun.send_email( {:error, [:foo]})
  end
end