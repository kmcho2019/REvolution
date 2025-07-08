module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // States
  typedef enum logic [1:0] {
    SEARCH = 2'b00,
    SHIFT_DELAY = 2'b01,
    COUNTING = 2'b10,
    DONE = 2'b11
  } state_t;
  
  state_t state, next_state;

  // Shift register for detecting pattern 1101
  reg [3:0] pattern_shift;

  // Shift register for delay bits
  reg [3:0] delay_shift;
  reg [2:0] delay_bits_received; // count how many delay bits shifted in (0 to 4)

  // Timer counters
  reg [9:0] cycle_count; // counts 0 to 999 (1000 cycles)
  reg [3:0] timer_count; // counts delay down to 0
  
  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      delay_shift <= 4'b0000;
      delay_bits_received <= 3'd0;
      cycle_count <= 10'd0;
      timer_count <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'dx;
    end else begin
      state <= next_state;
      
      case (state)
        SEARCH: begin
          // Shift in data to pattern_shift
          pattern_shift <= {pattern_shift[2:0], data};
        end
        
        SHIFT_DELAY: begin
          // Shift in delay bits MSB first (we shift bits one by one)
          if (delay_bits_received < 3'd4) begin
            delay_shift <= {delay_shift[2:0], data};
            delay_bits_received <= delay_bits_received + 1'b1;
          end
        end
        
        COUNTING: begin
          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            if (timer_count != 4'd0)
              timer_count <= timer_count - 1'b1;
          end else begin
            cycle_count <= cycle_count + 1'b1;
          end
        end
        
        DONE: begin
          // no registers updated except possibly waiting for ack
        end
      endcase
    end
  end

  // Next state logic and outputs
  always @* begin
    // Defaults
    next_state = state;
    counting = 1'b0;
    done = 1'b0;
    count = 4'dx;

    case (state)
      SEARCH: begin
        // Check pattern_shift for 1101 (4 bits)
        // pattern_shift[3:0] contains last 4 bits shifted in, MSB oldest
        // Pattern is 1101
        if (pattern_shift == 4'b1101) begin
          next_state = SHIFT_DELAY;
        end
      end

      SHIFT_DELAY: begin
        // Shift in delay bits
        // Once 4 bits shifted in, move to COUNTING
        if (delay_bits_received == 3'd4) begin
          next_state = COUNTING;
        end
      end

      COUNTING: begin
        counting = 1'b1;
        count = timer_count;

        // Count timer: (delay+1)*1000 cycles total
        // We decrement timer_count every 1000 cycles (cycle_count == 999)
        // When timer_count reaches 0 and cycle_count reaches 999, done
        if ((timer_count == 4'd0) && (cycle_count == 10'd999)) begin
          next_state = DONE;
        end
      end

      DONE: begin
        done = 1'b1;
        count = 4'dx;
        // Wait for ack to go to SEARCH
        if (ack) begin
          next_state = SEARCH;
        end
      end

      default: begin
        next_state = SEARCH;
      end
    endcase
  end

  // Load timer_count at start of COUNTING
  // Use a register to latch delay_shift at end of SHIFT_DELAY
  reg [3:0] delay_latched;
  always @(posedge clk) begin
    if (reset) begin
      delay_latched <= 4'd0;
    end else if ((state == SHIFT_DELAY) && (delay_bits_received == 3'd4)) begin
      delay_latched <= delay_shift;
    end
  end

  // Initialize timer_count and cycle_count at start of COUNTING
  always @(posedge clk) begin
    if (reset) begin
      timer_count <= 4'd0;
      cycle_count <= 10'd0;
    end else if ((state == SHIFT_DELAY) && (delay_bits_received == 3'd4)) begin
      timer_count <= delay_shift;
      cycle_count <= 10'd0;
    end else if (state == COUNTING) begin
      // timer_count and cycle_count updated in state register always block
    end
  end

endmodule