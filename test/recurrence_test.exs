defmodule RecurrenceTest do
  use ExUnit.Case
  doctest Recurrence
  use Timex
  
  test "one month iteration with end date" do
    dates = Recurrence.compute(
      # recurrence setup
      every: 1,
      interval: :months,
      starts: %Date{year: 2012, month: 1, day: 31},
      until: %Date{year: 2012, month: 4, day: 1},

      # computation window (TODO: split)
      from: %Date{year: 2012, month: 2, day: 1},
      to: %Date{year: 2012, month: 4, day: 1}
    )
    assert dates == [
      %Date{year: 2012, month: 2, day: 29},
      %Date{year: 2012, month: 3, day: 31},
    ]
  end

  test "one month iteration without end date" do
    dates = Recurrence.compute(
      # recurrence setup
      every: 1,
      interval: :months,
      starts: %Date{year: 2012, month: 1, day: 31},

      # computation window (TODO: split)
      from: %Date{year: 2012, month: 2, day: 1},
      to: %Date{year: 2012, month: 6, day: 1}
    )
    assert dates == [
      %Date{year: 2012, month: 2, day: 29},
      %Date{year: 2012, month: 3, day: 31},
      %Date{year: 2012, month: 4, day: 30},
      %Date{year: 2012, month: 5, day: 31},
    ]
  end
  
  test "two month iteration with end date" do
    dates = Recurrence.compute(
      # recurrence setup
      every: 2,
      interval: :months,
      starts: %Date{year: 2011, month: 12, day: 31},

      # computation window (TODO: split)
      from: %Date{year: 2012, month: 1, day: 25},
      to: %Date{year: 2012, month: 6, day: 1}
    )
    assert dates == [
      %Date{year: 2012, month: 2, day: 29},
      %Date{year: 2012, month: 4, day: 30},
    ]
  end
  
  test "one week iteration with end date" do
    dates = Recurrence.compute(
      # recurrence setup
      every: 1,
      interval: :weeks,
      starts: %Date{year: 2015, month: 12, day: 31}, # thursday

      # computation window (TODO: split)
      from: %Date{year: 2016, month: 6, day: 24},
      to: %Date{year: 2016, month: 7, day: 1}
    )
    assert dates == [
      %Date{year: 2016, month: 6, day: 30},
    ]
  end
  
  test "incorrect interval"
end
