---
name: return-shape
description: Use BEFORE editing lib/date_breakup.rb, build_breakdown, or any of the four public methods (in_years, in_months, in_weeks, in_days). Documents the locked return-shape contract — top-level hash keys, per-unit entry keys, and the stop-and-confirm rule that fires whenever a change would add, rename, or omit a key. Invoke when reviewing changes that touch the returned hash, when a spec around return shape fails, or when a user request implies a new key/field on year/month/week/day entries.
---

# Return Shape Contract

This skill documents the return shape contract for the `DateBreakup` gem. Anything you change in `lib/date_breakup.rb` must respect this contract.

## Top-level hash

All four public methods — `#in_years`, `#in_months`, `#in_weeks`, `#in_days` — return the **same** hash shape:

```ruby
{ years: [...], months: [...], weeks: [...], days: [...] }
```

Each value is an array of entry hashes. Higher-granularity methods leave coarser arrays empty rather than omitting the key.

## Per-unit entry keys

| Unit          | Keys (in addition to `:start_date`, `:end_date`)        | Source of value                            |
| ------------- | ------------------------------------------------------- | ------------------------------------------ |
| year entry    | `:year`                                                 | `date.year`                                |
| month entry   | `:month`, `:year`                                       | `date.month`, `date.year`                  |
| week entry    | `:week`, `:month`, `:year`                              | `date.cweek`, `date.month`, `date.year`    |
| day entry     | `:day`, `:month_day`, `:month`, `:year`                 | `date.yday`, `date.mday`, `date.month`, `date.year` |

Every entry, regardless of unit, also carries `:start_date` and `:end_date` (both `Date` instances). For day entries, `:start_date == :end_date`.

## Master example — `in_years` with leftover days

A range that spans one full calendar year plus a few trailing days, chosen so the leftover fits in fewer than seven days starting mid-week (so no full month or full Mon–Sun week can form):

```ruby
DateBreakup.between('01/01/2019', '05/01/2020').in_years
# => {
#   years: [
#     { year: 2019, start_date: Date.new(2019, 1, 1), end_date: Date.new(2019, 12, 31) }
#   ],
#   months: [],
#   weeks:  [],
#   days: [
#     { day: 1, month_day: 1, month: 1, year: 2020, start_date: Date.new(2020, 1, 1), end_date: Date.new(2020, 1, 1) },
#     { day: 2, month_day: 2, month: 1, year: 2020, start_date: Date.new(2020, 1, 2), end_date: Date.new(2020, 1, 2) },
#     { day: 3, month_day: 3, month: 1, year: 2020, start_date: Date.new(2020, 1, 3), end_date: Date.new(2020, 1, 3) },
#     { day: 4, month_day: 4, month: 1, year: 2020, start_date: Date.new(2020, 1, 4), end_date: Date.new(2020, 1, 4) },
#     { day: 5, month_day: 5, month: 1, year: 2020, start_date: Date.new(2020, 1, 5), end_date: Date.new(2020, 1, 5) }
#   ]
# }
```

This shows the contract end-to-end: `:years`, `:months`, `:weeks`, `:days` are all present; the populated arrays carry the keys listed in the per-unit table above; the empty arrays are still there as `[]`, not omitted.

## Consistency rule

- All four top-level keys (`:years`, `:months`, `:weeks`, `:days`) **must always be present** in the returned hash.
- All four public methods **must always include the same top-level keys** — they differ only in which arrays are populated, never in which keys exist.
- Per-unit entry keys must match the table above exactly. Do not add, rename, or omit a key on a single method while leaving the others alone.

## Adding a new key — STOP first

If there is ever a need to add a new key (to the top-level hash or to any per-unit entry), **stop completely. Do not write any code.**

Instead, describe the proposed change to the user and wait for explicit confirmation before proceeding. The description must include:

1. **Which unit** the key belongs to (top-level, year, month, week, or day entry — or all four methods if top-level).
2. **Key name** (the exact symbol).
3. **Value** (what it holds, what type, how it is computed from the current `date` / range).
4. **Reason** (why this key is needed, what it unlocks, why an existing key cannot serve).

Only proceed once the user has explicitly confirmed. Adding a key touches every public method and every consumer of the gem — it is not a unilateral change.
