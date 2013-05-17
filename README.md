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

```ruby
TimeChunk.each_day('2013-05-15T00:00:00Z'..'2013-05-20T23:59:59Z') do |range|
  puts range.inspect
end
```

```
2013-05-15 00:00:00 UTC..2013-05-15 23:59:59 UTC
2013-05-16 00:00:00 UTC..2013-05-16 23:59:59 UTC
2013-05-17 00:00:00 UTC..2013-05-17 23:59:59 UTC
2013-05-18 00:00:00 UTC..2013-05-18 23:59:59 UTC
2013-05-19 00:00:00 UTC..2013-05-19 23:59:59 UTC
2013-05-20 00:00:00 UTC..2013-05-20 23:59:59 UTC
```

If you supply a range of `Date`s instead of `Time` instances or strings,
`each_day` will yield `Date` instances instead of a time range.

```ruby
start = Date.parse '2013-05-15'
finish = Date.parse '2013-05-20'
TimeChunk.each_day(start..finish) do |d|
  puts d.to_s
end
```

```
2013-05-15
2013-05-16
2013-05-17
2013-05-18
2013-05-19
2013-05-20
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

This example uses the `6.hours` convenience method from `ActiveSupport`, but you
can supply any number of seconds.

### Enumerate using any chunk of days

`iterate_days` is the same as `iterate` except that the step size is specified
in days instead of seconds.

```ruby
start = Date.parse '2013-05-01'
finish = Date.parse '2013-05-31'
TimeChunk.iterate_days(start..finish, 5) do |range|
  puts "#{range.begin.to_s} .. #{range.end.to_s}"
end
```

```
2013-05-01 .. 2013-05-05
2013-05-06 .. 2013-05-10
2013-05-11 .. 2013-05-15
2013-05-16 .. 2013-05-20
2013-05-21 .. 2013-05-25
2013-05-26 .. 2013-05-30
2013-05-31 .. 2013-05-31
```
