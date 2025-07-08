module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // FSM states
  typedef enum logic [1:0] {
    SEARCH = 2'd0,
    SHIFT_DELAY = 2'd1,
    COUNT = 2'd2,
    DONE = 2'd3
  } state_t;

  state_t state, next_state;

  // Shift register for pattern detection and delay shifting
  reg [3:0] pattern_shift;
  reg [3:0] delay_reg;

  // Counters for timing
  reg [9:0] cycle_count;     // Counts up to 1000 cycles (0 to 999)
  reg [3:0] count_down;      // Counts down from delay_reg to 0

  // Flags
  wire pattern_match = (pattern_shift == 4'b1101);

  // Sequential logic - state and registers update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0;
      delay_reg <= 4'b0;
      cycle_count <= 10'd0;
      count_down <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'b0;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift data in for pattern detection
          pattern_shift <= {pattern_shift[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx; // don't-care during search
        end

        SHIFT_DELAY: begin
          // Shift in delay bits MSB first, use pattern_shift as shift register
          pattern_shift <= {pattern_shift[2:0], data};
          // shift in next 4 bits into delay_reg MSB first: we can collect in delay_reg one bit per clock from MSB down to LSB
          // We'll shift left delay_reg and put new bit in LSB for MSB first
          // But user says MSB first, so first bit shifted in is delay[3], last is delay[0]
          // We can implement this by shifting delay_reg left and inserting data at LSB each cycle for 4 cycles
          // We must count how many bits shifted in; use cycle_count (0-3)
          // So delay_reg <= {delay_reg[2:0], data};
          delay_reg <= {delay_reg[2:0], data};
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;

          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            if (count_down != 4'd0) begin
              count_down <= count_down - 4'd1;
            end
          end else begin
            cycle_count <= cycle_count + 10'd1;
          end

          count <= count_down;
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'bxxxx; // don't-care when done
        end

      endcase
    end
  end

  // FSM next state logic and auxiliary counters update
  reg [2:0] shift_delay_bits; // to count how many bits shifted in SHIFT_DELAY (0 to 3)

  always @(*) begin
    // defaults
    next_state = state;

    case (state)
      SEARCH: begin
        if (pattern_match) begin
          next_state = SHIFT_DELAY;
        end
      end

      SHIFT_DELAY: begin
        if (shift_delay_bits == 3'd3) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        // Count completes when count_down == 0 and cycle_count == 999
        if ((count_down == 4'd0) && (cycle_count == 10'd999)) begin
          next_state = DONE;
        end
      end

      DONE: begin
        if (ack) begin
          next_state = SEARCH;
        end
      end
    endcase
  end

  // Sequential logic for shift_delay_bits and count_down loading
  always @(posedge clk) begin
    if (reset) begin
      shift_delay_bits <= 3'd0;
      count_down <= 4'd0;
    end else begin
      case (state)
        SEARCH: begin
          shift_delay_bits <= 3'd0;
          count_down <= 4'd0;
        end

        SHIFT_DELAY: begin
          if (shift_delay_bits < 3'd3) begin
            shift_delay_bits <= shift_delay_bits + 3'd1;
          end else begin
            shift_delay_bits <= 3'd0; // reset at end
          end
        end

        COUNT: begin
          // Load count_down from delay_reg at start of COUNT state
          // We can detect start of COUNT state by looking at previous state or at shift_delay_bits reset
          // But simpler: when state transitions from SHIFT_DELAY to COUNT, load count_down
          // So implement in a separate always block below to detect this transition
        end

        DONE: begin
          shift_delay_bits <= 3'd0;
          count_down <= count_down; // hold count_down
        end
      endcase
    end
  end

  // Detect rising edge of COUNT state to load count_down
  reg [1:0] state_d;
  always @(posedge clk) begin
    if (reset) begin
      state_d <= 2'd0;
      count_down <= 4'd0;
    end else begin
      state_d <= state;
      if (state == COUNT && state_d == SHIFT_DELAY) begin
        // Load count_down with delay_reg
        count_down <= delay_reg;
        cycle_count <= 10'd0; // reset cycle count at start of COUNT
      end
    end
  end

endmodule