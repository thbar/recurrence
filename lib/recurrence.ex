defmodule Recurrence do
  def compute(options) do
    starts = Keyword.fetch!(options, :starts)
    until = Keyword.get(options, :until)
    every = Keyword.fetch!(options, :every)
    interval = Keyword.fetch!(options, :interval)
    
    compute_from = Keyword.fetch!(options, :from)
    compute_to = Keyword.fetch!(options, :to)

    recur(starts, until, every, interval, compute_from, compute_to, 0, [])
  end

  def shift!(date, parameters) do
    case Timex.shift(date, parameters) do
      {:error, _term} ->
        # TODO: propagate term up there
        raise "Time shift failed with error"
      output ->
        output
    end
  end

  # TODO: verify how we could replace this by Timex.Interval
  # TODO: create an enumerator for long series support
  def recur(starts, until, every, interval, compute_from, compute_to, index, results) do
    # TODO: handle error (e.g. wrong interval type)
    date = shift!(starts, [{interval, index * every}])
    cond do
      # Have we reached the end of the observation window?
      # TODO: use after?
      Timex.Date.compare(date, compute_to) > 0 ->
        results # stop recurrence
      # Have we reached the optional upper bound of the recurrence?
      until && (Timex.Date.compare(date, until) > 0) ->
        results # stop recurrence
      # Are we inside the observation window? If so keep the record
      Timex.Date.compare(date, compute_from) >= 0 ->
        [date | recur(starts, until, every, interval, compute_from, compute_to, index + 1, results)]
      # Otherwise just skip a beat without adding the record
      true ->
        recur(starts, until, every, interval, compute_from, compute_to, index + 1, results)
    end
  end
end
