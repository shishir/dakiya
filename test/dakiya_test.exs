defmodule DakiyaTest do
  use ExUnit.Case
  doctest Dakiya

  test "parses message out" do
    args = ["--message={\"to\": \"shishir.das@gmail.com\", \"subject\":  \"Example Email\", \"body\":  \"<html>foobar</html>\"}"]

    assert Dakiya.parse_args(args) ==  %{
              "body" => "<html>foobar</html>",
              "subject" => "Example Email",
              "to" => "shishir.das@gmail.com"
            }
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
end