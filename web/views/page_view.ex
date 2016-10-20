defmodule Pings.PageView do
  use Pings.Web, :view
  def render(_, %{data: data}), do: data
end
