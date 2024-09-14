defmodule PlugExperimentWeb.Plugs.Ymn do
  import Plug.Conn
  alias Phoenix.Controller

  def init(opts \\ []) do
    IO.inspect("------------ #{__MODULE__}.init ------------")

    opts
    |> IO.inspect()
  end

  def call(conn, _opts) do
    IO.inspect("------------ #{__MODULE__}.call ------------")

    os =
      conn.req_headers
      |> Enum.filter(fn {key, _val} -> key == "user-agent" end)
      |> List.first()
      |> elem(1)
      |> IO.inspect()
      |> os()
      |> IO.inspect()

    conn
    |> ipd_redirect(os)
  end

  defp ipd_redirect(conn, "iPadOS") do
    IO.inspect("redirect https://www.apple.com/jp/ipad/")

    conn
    |> Controller.redirect(external: "https://www.apple.com/jp/ipad/")
    |> halt()
  end

  defp ipd_redirect(conn, _), do: conn

  defp os(agent) do
    cond do
      String.match?(agent, ~r/iPad/) -> "iPadOS"
      String.match?(agent, ~r/X11/) -> "Linux"
      String.match?(agent, ~r/Android/) -> "Android"
      true -> "unknown"
    end
  end
end
