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
      |> get_os_name()
      |> IO.inspect()

    conn
    |> redirect(os)
  end

  defp redirect(conn, "iPadOS") do
    IO.inspect("redirect https://www.apple.com/jp/ipad/")

    conn
    |> Controller.redirect(external: "https://www.apple.com/jp/ipad/")
    |> halt()
  end

  defp redirect(conn, _), do: conn

  defp get_os_name(agent) do
    cond do
      String.match?(agent, ~r/iPad/) -> "iPadOS"
      String.match?(agent, ~r/X11/) -> "Linux"
      String.match?(agent, ~r/Android/) -> "Android"
      true -> "unknown"
    end
  end
end
