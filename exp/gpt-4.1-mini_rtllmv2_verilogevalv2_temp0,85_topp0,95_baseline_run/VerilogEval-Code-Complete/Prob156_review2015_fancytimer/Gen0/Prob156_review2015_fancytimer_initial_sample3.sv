module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // State encoding
  typedef enum logic [1:0] {
    IDLE       = 2'b00,
    SHIFT_DELAY= 2'b01,
    COUNT      = 2'b10,
    DONE       = 2'b11
  } state_t;

  state_t state, next_state;

  // Pattern detection shift register
  reg [3:0] pattern_shift;

  // Delay register
  reg [3:0] delay;

  // Shift delay counter (counts 0..3)
  reg [2:0] shift_delay_count;

  // Cycle counter for counting 1000 cycles (0..999)
  reg [9:0] cycle_counter;

  // Delay countdown register (copy of delay, counts down to 0)
  reg [3:0] delay_countdown;

  // Pattern to detect: 1101 (binary)
  localparam [3:0] PATTERN = 4'b1101;

  // State registers
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shift <= 4'b0;
      delay <= 4'b0;
      shift_delay_count <= 3'b0;
      cycle_counter <= 10'b0;
      delay_countdown <= 4'b0;
      count <= 4'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        IDLE: begin
          // Shift in pattern bits
          pattern_shift <= {pattern_shift[2:0], data};
        end
        SHIFT_DELAY: begin
          // Shift in delay bits MSB first
          delay <= {delay[2:0], data};
          shift_delay_count <= shift_delay_count + 1'b1;
        end
        COUNT: begin
          // Counting logic
          if (cycle_counter == 999) begin
            cycle_counter <= 0;
            if (delay_countdown != 0)
              delay_countdown <= delay_countdown - 1'b1;
          end else begin
            cycle_counter <= cycle_counter + 1'b1;
          end
          count <= delay_countdown;
        end
        DONE: begin
          // wait for ack
          // nothing to update here except outputs
        end
      endcase
    end
  end

  // Next state logic and output control
  always @(*) begin
    next_state = state;
    counting = 0;
    done = 0;
    count = 4'bxxxx;  // default don't-care

    case (state)
      IDLE: begin
        counting = 0;
        done = 0;
        count = 4'bxxxx;
        // If pattern detected, move to SHIFT_DELAY and reset shift_delay_count
        if (pattern_shift == PATTERN) begin
          next_state = SHIFT_DELAY;
        end
      end

      SHIFT_DELAY: begin
        counting = 0;
        done = 0;
        count = 4'bxxxx;
        // After shifting 4 bits, start counting
        if (shift_delay_count == 3'd3) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        counting = 1;
        done = 0;
        count = delay_countdown;

        // Check if counting finished
        // Counting duration: (delay + 1)*1000 cycles
        // delay_countdown counts from delay down to 0
        // cycle_counter counts 0..999
        if ((delay_countdown == 0) && (cycle_counter == 999)) begin
          next_state = DONE;
        end
      end

      DONE: begin
        counting = 0;
        done = 1;
        count = 4'bxxxx;
        // Wait for ack to return to IDLE
        if (ack) begin
          next_state = IDLE;
        end
      end

      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // Initialize registers when entering states
  always @(posedge clk) begin
    if (reset) begin
      // already handled in main always block
    end else begin
      if (state != next_state) begin
        case (next_state)
          IDLE: begin
            pattern_shift <= 4'b0;
            shift_delay_count <= 3'b0;
            cycle_counter <= 10'b0;
            delay_countdown <= 4'b0;
            delay <= 4'b0;
            count <= 4'bxxxx;
            counting <= 0;
            done <= 0;
          end

          SHIFT_DELAY: begin
            // Reset shift delay count to 0 at start
            shift_delay_count <= 3'b0;
            delay <= 4'b0;
          end

          COUNT: begin
            cycle_counter <= 0;
            delay_countdown <= delay;
          end

          DONE: begin
            // Nothing to init here
          end
        endcase
      end
    end
  end

endmodule