defmodule Egaugex do
  # require Logger
  require HTTPoison

  @moduledoc """
  Gets and parses egauge data given the egauge device id
  """

  @doc """
  Module entry point to be used by external programs
  """
  def egauge_parser(egauge_id, username \\ nil, password \\ nil, uri \\ "/cgi-bin/egauge-show?S&n=60", realm \\ "eGauge Administration") do
    result = Egaugex.Fetcher.get_egauge_data(egauge_id, username, password, uri, realm)
    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      _ ->
        {:error, "An error occurred while fetching data!"}
    end
  end

  defmodule Auth do
    @moduledoc """
    Egaugex.Auth - module to create digest header that's compatible with egauge http service
    """

    @doc """
    Creates digest authorization header based on username, password, uri, realm and method
    """
    def create_digest_auth_header(username, password, uri, realm, method \\ "GET") do
      ha1 = :crypto.hash(:md5, Enum.join([username, realm, password], ":")) |> Base.encode16 |> String.downcase
      ha2 = :crypto.hash(:md5, Enum.join([method, uri], ":")) |> Base.encode16 |> String.downcase
      nonce = :crypto.hash(:md5, random_string(16)) |> Base.encode16 |> String.downcase
      auth = :crypto.hash(:md5, Enum.join([ha1, nonce, ha2], ":")) |> Base.encode16 |> String.downcase
      'Digest username="#{username}", realm="#{realm}", nonce="#{nonce}", uri="#{uri}", response="#{auth}", opaque=""'
    end

    @doc """
    Creates random string of given length
    Used for random nonce creation
    """
    def random_string(length) do
      :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
    end
  end

  defmodule Fetcher do
    use HTTPoison.Base

    @moduledoc """
    Module to fetch data from egauge cloud
    Also performs transformation via HTTPoison.Base overrides
    """

    # @doc """
    # Create url from base_url and first parameter of HTTPoison get/post/put/delete
    # """
    # def process_url(device_ident) do
    #   uri = "/cgi-bin/egauge-show?S&n=60"
    #   "http://egauge17983.egaug.es#{uri}"
    # end

    @doc """
    Decode the xml response body
    """
    @spec process_response_body(binary) :: term
    def process_response_body(body) do
      # this is the perfect place to add custom logic for response body
      body
      |> Egaugex.Parser.parse_egauge_data
    end

    def process_response(%HTTPoison.Response{status_code: 200, body: body}), do: body
    def process_response(%HTTPoison.Response{status_code: status_code, body: body }), do: { status_code, body }

    @doc """
    Gets egauge data from egauge cloud
    """
    def get_egauge_data(device_ident, username, password, uri, realm) do
      # if username and password are set, get the auth header
      auth_header = nil
      if username != nil && password != nil do
        auth_header = Egaugex.Auth.create_digest_auth_header(username, password, uri, realm)
      end
      url = "http://#{device_ident}.egaug.es#{uri}"
      get(url, [{"Authorization", auth_header}])
    end
  end

  defmodule Parser do
    @moduledoc """
    Parser module to parse the xml body
    """

    @doc """
    Parses egauge data body and returns a map of attribute, register and values
    """
    def parse_egauge_data(data) do
      [{_, atts, values} | _rest] = Floki.find(data, "data")

      # get attributes
      atts = atts |> Enum.map(fn {name, value} ->
          case value do
              "0x" <> num -> {name, hex_to_int(num)}
              _ -> {name, value}
          end
      end) |> Enum.into(%{})

      # get first register name
      {_, _, [register_name]} = Floki.find(values, "cname") |> List.first

      # get values for first register name
      values = Floki.find(values, "r") |> Enum.map(fn r ->
          {_, _, [value]} = Floki.find(r, "c") |> List.first
          value
      end)
      %{attributes: atts, register: register_name, values: values}
    end

    @doc """
    Converts hex to integer value
    """
    def hex_to_int(hex) do
      hex |> String.upcase |> Base.decode16! |> :binary.decode_unsigned |> to_string
    end
  end
end