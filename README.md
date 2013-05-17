# time_chunk

Iterate over a time range in discrete chunks.

## examples

### Enumerate each hour in a day.
```ruby
TimeChunk.each_hour('2013-05-15T00:00:00Z'..'2013-05-15T05:59:59Z') do |range|
  puts range.inspect
end
```

Strings are parsed into `Time` instances automatically.

```
2013-05-15 00:00:00 UTC..2013-05-15 00:59:59 UTC
2013-05-15 01:00:00 UTC..2013-05-15 01:59:59 UTC
2013-05-15 02:00:00 UTC..2013-05-15 02:59:59 UTC
2013-05-15 03:00:00 UTC..2013-05-15 03:59:59 UTC
2013-05-15 04:00:00 UTC..2013-05-15 04:59:59 UTC
2013-05-15 05:00:00 UTC..2013-05-15 05:59:59 UTC
```

### Enumerate a range of days.

If you supply `Date`s instead of `Time` instances or strings, the
members of the yielded range will also be `Date`s.

```ruby
start = Date.parse '2013-05-15'
finish = Date.parse '2013-05-20'
TimeChunk.each_day(start..finish) do |range|
  puts range.to_s
end
```

```
2013-05-15..2013-05-15
2013-05-16..2013-05-16
2013-05-17..2013-05-17
2013-05-18..2013-05-18
2013-05-19..2013-05-19
2013-05-20..2013-05-20
```

### Enumerate using any chunk of time

```ruby
TimeChunk.iterate('2013-05-15T00:00:00Z'..'2013-05-15T23:59:59Z', 6.hours) do |range|
  puts range.inspect
end
```

```
2013-05-15 00:00:00 UTC..2013-05-15 05:59:59 UTC
2013-05-15 06:00:00 UTC..2013-05-15 11:59:59 UTC
2013-05-15 12:00:00 UTC..2013-05-15 17:59:59 UTC
2013-05-15 18:00:00 UTC..2013-05-15 23:59:59 UTC
```
