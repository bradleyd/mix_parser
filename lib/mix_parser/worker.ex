defmodule MixParser.Worker do
  use GenServer
  require Logger

  ## Client API
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def parse_lock_file(str) do
    GenServer.call(__MODULE__, {:parse, str})
  end

  ## Private
  def init(opts) do
    {:ok, opts}
  end

  # TODO need to handle errors from hex.pm better
  def handle_call({:parse, str}, _from, state) do
    #Logger.debug("Working on str: #{str}")
    {lock_deps, _} = Code.eval_string(str)
    data =
      Enum.reduce(lock_deps, [], fn(dep, acc) ->
        case dep do
          {name, {:hex, _, version, _hash, _, _, _child_deps}} ->
            latest_version = get_current_package_version(name)
            [%{name: name, lock_version: version, latest_version: latest_version, upgrade_available: latest_version > version} | acc ]
          {name, {:git, _path, _hash, []}} ->
            latest_version = get_current_package_version(name)
            [%{name: name, lock_version: :latest, latest_version: latest_version, upgrade_available: false} | acc ]
          _ -> acc
        end
      end)
    {:reply, data, state}
  end

  defp get_current_package_version(name) do
    url = "https://hex.pm/api/packages/#{name}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data = Poison.decode!(body)
        Map.get(data, "releases") |> List.first |> Map.get("version")
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        :not_found
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
