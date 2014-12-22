require "tm4rb/version"
require 'pp'

#
# @author Alexander Rüedlinger <a.rueedlinger@gmail.com>
# @date 22.12.2014
#

module Tm4rb

  #
  # A class that represents an infinite tape.
  #
  class Tape
    include Enumerable

    BLANK = ''

    def initialize(a_list=[])
      @positive_array = a_list || []
      @negative_array = []
    end

    def [](pos)
      set_default(pos)
      if pos >= 0
        @positive_array[pos]
      elsif pos < 0
        @negative_array[pos.abs]
      else
        raise 'Error []: index %s is not supported!' % pos
      end
    end

    def []=(pos, value)
      if pos >= 0
        @positive_array[pos] = value
      elsif pos < 0
        @negative_array[pos.abs] = value
      else
        raise 'Error []=: index %s is not supported!' % pos
      end
    end

    def set_default(pos)
      if pos >= 0
        @positive_array[pos] = BLANK if @positive_array[pos].nil?
      elsif pos < 0
        @negative_array[pos.abs] = BLANK if @negative_array[pos.abs].nil?
      else
        raise 'Error'
      end
    end

    def each(&block)
      a_list = @negative_array + @positive_array
      a_list.each do |a_item|
        block.call a_item
      end
    end

    def to_a
      @negative_array + @positive_array
    end

  end

  #
  # A class which can be used to chain multiple turing machines together.
  #
  class ChainedTuringMachine

    attr_reader :output

    def initialize(tms=[])
      @tms = tms || []
      @output = ''
    end

    def chain(tm)
      @tms << tm
    end

    def run(init_input)
      @output = @tms.reduce(init_input) do |input, tm|
        tm.run input
        tm.output
      end
    end

  end

  #
  # A class which represents a turing machine.
  #
  class TuringMachine
    attr_accessor :delta, :final_state, :initial_state
    attr_reader :current_state, :current_index, :tape

    def initialize(&block)
      if block_given?
        block.call self
      end
      init
    end

    def init
      @current_index = 0
      @current_state = initial_state
    end

    def run(input, verbose=false)
      init
      # split input into tokens
      @tape = Tape.new input.split("")

      loop do
        token = @tape[current_index]

        # if we reach the final state terminate
        return if current_state == final_state

        # get the current transition
        transition = delta[[current_state, token]]
        if verbose
          pp [[current_state, token], '->', transition]
        end
        new_state, output, op = transition

        @tape[current_index] = output
        @current_state = new_state
        @current_index = case op
                           when :R
                             current_index + 1
                           when :L
                             current_index - 1
                           when :O
                             current_index
                           else
                             raise 'Op not supported: %s' % op
                         end
      end
    end

    def output
      @tape.to_a.join('')
    end

  end

end
