defmodule SphereTodoWeb.PageController do
  use SphereTodoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
