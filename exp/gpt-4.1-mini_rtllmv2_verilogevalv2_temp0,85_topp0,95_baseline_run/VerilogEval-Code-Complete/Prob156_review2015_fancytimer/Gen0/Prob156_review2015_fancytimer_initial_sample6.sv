module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // States encoding
  localparam STATE_SEARCH     = 2'd0;
  localparam STATE_SHIFT_DELAY= 2'd1;
  localparam STATE_COUNTING   = 2'd2;
  localparam STATE_DONE       = 2'd3;

  reg [1:0] state, next_state;

  // For pattern detection: shift register holding last 4 bits
  reg [3:0] pattern_shift;

  // For delay shift-in
  reg [2:0] delay_bits_shifted; // counts from 0 to 3 for shifting 4 bits
  reg [3:0] delay;

  // Cycle counter for 1000 cycles (max 10 bits needed)
  reg [9:0] cycle_counter;

  // Count down register for current delay count
  reg [3:0] count_down;

  // Wires and constants
  localparam START_PATTERN = 4'b1101;
  localparam CYCLES_PER_COUNT = 10'd1000;

  // Synchronous reset and state register
  always @(posedge clk) begin
    if (reset) begin
      state <= STATE_SEARCH;
      pattern_shift <= 4'd0;
      delay <= 4'd0;
      delay_bits_shifted <= 3'd0;
      cycle_counter <= 10'd0;
      count_down <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'd0;
    end else begin
      state <= next_state;

      case (state)
        STATE_SEARCH: begin
          // Shift in data to pattern_shift
          pattern_shift <= {pattern_shift[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0; // don't care, set to zero

          // No delay or counters updated here
          delay_bits_shifted <= 3'd0;
          cycle_counter <= 10'd0;
          count_down <= 4'd0;
        end

        STATE_SHIFT_DELAY: begin
          // Shift in delay bits MSB first: shift left and add data
          delay <= {delay[2:0], data};
          delay_bits_shifted <= delay_bits_shifted + 1'b1;

          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0; // don't care
        end

        STATE_COUNTING: begin
          counting <= 1'b1;
          done <= 1'b0;
          count <= count_down;

          if (cycle_counter == CYCLES_PER_COUNT - 1) begin
            cycle_counter <= 10'd0;
            if (count_down != 4'd0) begin
              count_down <= count_down - 1'b1;
            end else begin
              // count_down == 0 and cycle_counter full means timer done
              // We will transition to DONE state in combinational logic
            end
          end else begin
            cycle_counter <= cycle_counter + 1'b1;
          end
        end

        STATE_DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'd0; // don't care
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      STATE_SEARCH: begin
        if (pattern_shift == START_PATTERN) begin
          next_state = STATE_SHIFT_DELAY;
        end else begin
          next_state = STATE_SEARCH;
        end
      end

      STATE_SHIFT_DELAY: begin
        if (delay_bits_shifted == 3'd3) begin
          next_state = STATE_COUNTING;
        end else begin
          next_state = STATE_SHIFT_DELAY;
        end
      end

      STATE_COUNTING: begin
        // When timer done, move to DONE state
        // Timer done when count_down==0 and cycle_counter == 999 (last cycle)
        if ((count_down == 4'd0) && (cycle_counter == CYCLES_PER_COUNT - 1)) begin
          next_state = STATE_DONE;
        end else begin
          next_state = STATE_COUNTING;
        end
      end

      STATE_DONE: begin
        // Wait for ack=1 to reset to search
        if (ack) begin
          next_state = STATE_SEARCH;
        end else begin
          next_state = STATE_DONE;
        end
      end

      default: next_state = STATE_SEARCH;
    endcase
  end

endmodule