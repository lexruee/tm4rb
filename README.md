# Tm4rb

This is a simple class for creating turing machines!
For more details [see](http://en.wikipedia.org/wiki/Turing_machine).

A turing machine is defined as follows:
```ruby
tm = Tm4rb::TuringMachine.new do |m|
    m.initial_state = :s0 # use a symbol to define the initial state
    m.final_state = :sf # use a symbol to define the final state
    m.delta = { # the delta function is encoded as a lookup table
        
         # if we read a zero in state s0 go to state sf
        [:s0,'0'] => [:sf,'1',:R], # and write a one and move the head to right.
         
        # if we read a one in state s0 go to state sf 
        [:s0,'1'] => [:sf,'1',:R], # and write a one and move the head to right.
        
        # if we read a blank symbol in state so go to state sf
        [:s0,'' => [:sf,'1',:R] # and write one and move the head to right
    }
end

tm.run('0')
puts tm.output

```


Example (double ones):
```ruby
#'' is a blank symbol
 tm = Tm4rb::TuringMachine.new do |m|
      m.final_state = :s6
      m.initial_state = :s1
      m.delta = {
          [:s1,'1'] => [:s2,'',:R],
          [:s1,''] => [:s6,'',:O],

          [:s2,'1'] => [:s2,'1',:R],
          [:s2,''] => [:s3,'',:R],

          [:s3,'1'] => [:s3,'1',:R],
          [:s3,''] => [:s4,'1',:L],

          [:s4,'1'] => [:s4,'1',:L],
          [:s4,''] => [:s5,'',:L],

          [:s5,'1'] => [:s5,'1',:L],
          [:s5,''] => [:s1,'1',:R],
      }
    end

    tm.run("11")
    puts tm.output # => 1111
```

Example (add one):
```ruby
#'' is a blank symbol
 tm = Tm4rb::TuringMachine.new do |m|
      m.final_state = :sf
      m.initial_state = :s0
      m.delta = {
          [:s0,'0'] => [:s0,'0',:R],
          [:s0,'1'] => [:s0,'1',:R],
          [:s0,''] => [:s1,'',:L],

          [:s1,'0'] => [:s2,'1',:L],
          [:s1,'1'] => [:s1,'0',:L],
          [:s1,''] => [:sf,'1',:O],

          [:s2,'0'] => [:s2,'0',:L],
          [:s2,'1'] => [:s2,'1',:L],
          [:s2,''] => [:sf,'',:R]
      }
    end
    tm.run('010')
    puts tm.output #=> 011
```

Example (chained tm):
```ruby
#'' is a blank symbol
chained_tm = Tm4rb::ChainedTuringMachine.new
    15.times do
      tm = Tm4rb::TuringMachine.new do |m|
        m.final_state = :sf
        m.initial_state = :s0
        m.delta = {
            [:s0,'0'] => [:s0,'0',:R],
            [:s0,'1'] => [:s0,'1',:R],
            [:s0,''] => [:s1,'',:L],

            [:s1,'0'] => [:s2,'1',:L],
            [:s1,'1'] => [:s1,'0',:L],
            [:s1,''] => [:sf,'1',:O],

            [:s2,'0'] => [:s2,'0',:L],
            [:s2,'1'] => [:s2,'1',:L],
            [:s2,''] => [:sf,'',:R]
        }
      end
      chained_tm.chain tm
    end
    chained_tm.run('0')
    puts '[16]b=?: ' + chained_tm.output
```