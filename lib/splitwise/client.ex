defmodule ExSplitwise.Client do
  @moduledoc """
  Defines the `ExSplitwise.Client` struct, and the HTTP requests functions to hit the Splitwise API.
  """

  import ExSplitwise.OAuth2.Client, only: [access_token: 0]

  @base_url "https://secure.splitwise.com"

  alias ExSplitwise.Client.Response

  def get!(url) do
    result = http().get!("#{@base_url}#{url}", Authorization: "Bearer #{access_token()}")

    %Response{
      body: decode!(result.body),
      status: result.status_code,
      headers: result.headers
    }
  end

  def post!(url) do
    post!(url, [])
  end

  def post!(url, body) do
    result =
      http().post!(
        "#{@base_url}#{url}",
        {:form, body},
        Authorization: "Bearer #{access_token()}"
      )

    %Response{
      body: decode!(result.body),
      status: result.status_code,
      headers: result.headers
    }
  end

  defp decode!(json), do: json_lib().decode!(json)

  defp json_lib(), do: Application.get_env(:ex_splitwise, :json_library, Poison)

  defp http(), do: Application.get_env(:ex_splitwise, :http)
end
