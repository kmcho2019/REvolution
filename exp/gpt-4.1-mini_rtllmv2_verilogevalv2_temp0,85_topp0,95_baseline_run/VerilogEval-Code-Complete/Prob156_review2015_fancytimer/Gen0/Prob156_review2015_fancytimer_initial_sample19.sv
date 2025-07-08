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
  typedef enum logic [2:0] {
    SEARCH      = 3'd0,
    READ_DELAY  = 3'd1,
    COUNT       = 3'd2,
    DONE        = 3'd3
  } state_t;

  state_t state, next_state;

  // For detecting 1101 pattern, keep last 4 bits shifted in
  reg [3:0] pattern_shift;

  // For reading delay bits MSB first (4 bits)
  reg [3:0] delay;
  reg [2:0] delay_bit_count; // count from 0 to 3

  // Counting cycles
  reg [9:0] cycle_counter; // counts up to 1000 (0 to 999)
  reg [3:0] delay_counter; // counts down from delay to 0

  // Sequential logic for state transitions and registers
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      delay <= 4'd0;
      delay_bit_count <= 3'd0;
      cycle_counter <= 10'd0;
      delay_counter <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'd0;
    end else begin
      state <= next_state;
      case(state)
        SEARCH: begin
          done <= 1'b0;
          counting <= 1'b0;
          // Shift in data bit to pattern_shift
          pattern_shift <= {pattern_shift[2:0], data};
          // Outputs irrelevant here, count don't care
          count <= 4'd0;
        end

        READ_DELAY: begin
          // Shift in delay bits MSB first
          if (delay_bit_count < 3'd4) begin
            // Shift delay left and insert current data bit as LSB
            delay <= {delay[2:0], data};
            delay_bit_count <= delay_bit_count + 1'b1;
          end
          count <= 4'd0;
          counting <= 1'b0;
          done <= 1'b0;
          pattern_shift <= pattern_shift; // no change
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;
          // cycle_counter counts 0 to 999
          if (cycle_counter == 10'd999) begin
            cycle_counter <= 10'd0;
            // decrement delay_counter if not zero
            if (delay_counter != 4'd0) begin
              delay_counter <= delay_counter - 1'b1;
            end
          end else begin
            cycle_counter <= cycle_counter + 1'b1;
          end

          count <= delay_counter;
          pattern_shift <= pattern_shift; // no change
          delay_bit_count <= delay_bit_count; // no change
          delay <= delay; // no change
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'd0; // don't care
          pattern_shift <= pattern_shift; // no change
          delay <= delay; // no change
          delay_bit_count <= delay_bit_count; // no change
          cycle_counter <= cycle_counter; // no change
          delay_counter <= delay_counter; // no change
        end

        default: begin
          // safety defaults
          state <= SEARCH;
          pattern_shift <= 4'b0000;
          delay <= 4'd0;
          delay_bit_count <= 3'd0;
          cycle_counter <= 10'd0;
          delay_counter <= 4'd0;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      SEARCH: begin
        // Check if pattern_shift equals 1101 = 4'b1101
        // pattern_shift updates on clock edge, so next_state logic reads current value
        if (pattern_shift == 4'b1101) begin
          next_state = READ_DELAY;
        end else begin
          next_state = SEARCH;
        end
      end

      READ_DELAY: begin
        if (delay_bit_count == 3'd4) begin
          next_state = COUNT;
        end else begin
          next_state = READ_DELAY;
        end
      end

      COUNT: begin
        // delay_counter is loaded at start of COUNT state, counts down every 1000 cycles
        // When delay_counter == 0 and cycle_counter == 999, counting done
        if ((delay_counter == 4'd0) && (cycle_counter == 10'd999)) begin
          next_state = DONE;
        end else begin
          next_state = COUNT;
        end
      end

      DONE: begin
        // Wait for ack high to restart searching
        if (ack == 1'b1) begin
          next_state = SEARCH;
        end else begin
          next_state = DONE;
        end
      end

      default: next_state = SEARCH;
    endcase
  end

  // Load delay_counter at start of COUNT state
  always @(posedge clk) begin
    if (reset) begin
      delay_counter <= 4'd0;
    end else begin
      if ((state == READ_DELAY) && (delay_bit_count == 3'd4)) begin
        // After reading 4 bits delay, load delay_counter for counting
        delay_counter <= delay;
        cycle_counter <= 10'd0;
      end else if (state == COUNT && cycle_counter == 10'd999) begin
        // decrement happens above in main always block
        // already handled
      end
    end
  end

endmodule