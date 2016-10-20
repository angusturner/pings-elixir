# Pings

## Requirements
  * Elixir and the Phoenix web framework. Installation guides can be found here (http://www.phoenixframework.org/docs/installation)
  * PostgreSQL

## Instructions
  * Configure the database settings in `config/dev.exs`.
  * Install dependencies with `mix deps.get`
  * Setup the database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

The server runs at [`localhost:4000`](http://localhost:4000)

## Further notes
A lot of boilerplate relating to compilation and serving of static assets could probably removed.
The key project files are:
  * Routing: `web/router.ex`
  * Controller: `web/controllers/ping_controller.ex`
  * Model: `web/models/ping.ex`
  * Views: `web/views/page_view.ex` (just renders the JSON output)  
