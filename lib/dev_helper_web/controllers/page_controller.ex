defmodule DevHelperWeb.PageController do
  use DevHelperWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
