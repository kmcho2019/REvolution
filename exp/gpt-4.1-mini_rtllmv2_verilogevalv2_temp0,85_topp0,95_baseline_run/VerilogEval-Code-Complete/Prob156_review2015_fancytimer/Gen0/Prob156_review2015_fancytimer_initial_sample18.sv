module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // State definitions
  localparam STATE_SEARCH      = 2'd0;
  localparam STATE_SHIFT_DELAY = 2'd1;
  localparam STATE_COUNTING    = 2'd2;
  localparam STATE_DONE        = 2'd3;

  reg [1:0] state, next_state;

  // For pattern detection (1101)
  reg [3:0] pattern_shift;

  // Delay register
  reg [3:0] delay;

  // Counter for counting 1000 cycles per delay decrement
  reg [9:0] cycle_count; // counts 0 to 999

  // Delay countdown for output and control
  reg [3:0] delay_countdown;

  // Bit counter for shifting in delay bits (4 bits)
  reg [2:0] bits_shifted; // max 4

  // State transition and logic
  always @(posedge clk) begin
    if (reset) begin
      state <= STATE_SEARCH;
      pattern_shift <= 4'b0;
      delay <= 4'b0;
      cycle_count <= 10'd0;
      delay_countdown <= 4'd0;
      bits_shifted <= 3'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'b0;
    end else begin
      state <= next_state;

      case (state)
        STATE_SEARCH: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0;
          cycle_count <= 10'd0;
          delay <= 4'b0;
          delay_countdown <= 4'b0;
          bits_shifted <= 3'd0;

          // Shift in data for pattern detection
          pattern_shift <= {pattern_shift[2:0], data};
        end

        STATE_SHIFT_DELAY: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0;

          // Shift in delay bits MSB first, so we shift left and insert data at LSB
          // We'll build delay register bit by bit
          delay <= {delay[2:0], data};
          bits_shifted <= bits_shifted + 1'b1;
        end

        STATE_COUNTING: begin
          done <= 1'b0;
          counting <= 1'b1;
          count <= delay_countdown;

          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            if (delay_countdown == 4'd0) begin
              // Finished counting
              // Keep count at 0 during done state, so remain here until transition
            end else begin
              delay_countdown <= delay_countdown - 1'b1;
            end
          end else begin
            cycle_count <= cycle_count + 1'b1;
          end
        end

        STATE_DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'b0;
          cycle_count <= 10'd0;
          delay <= 4'b0;
          delay_countdown <= 4'b0;
          bits_shifted <= 3'd0;
          pattern_shift <= pattern_shift; // keep pattern_shift unchanged
        end

        default: begin
          // Defensive default
          state <= STATE_SEARCH;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0;
          cycle_count <= 10'd0;
          delay <= 4'b0;
          delay_countdown <= 4'b0;
          bits_shifted <= 3'd0;
          pattern_shift <= 4'b0;
        end
      endcase
    end
  end

  // Next state logic combinational
  always @(*) begin
    next_state = state;
    case(state)
      STATE_SEARCH: begin
        // Check if pattern_shift matches 1101
        // pattern_shift updates on rising edge, so we check current pattern_shift
        if (pattern_shift == 4'b1101) begin
          next_state = STATE_SHIFT_DELAY;
        end else begin
          next_state = STATE_SEARCH;
        end
      end

      STATE_SHIFT_DELAY: begin
        if (bits_shifted == 3'd4) begin
          next_state = STATE_COUNTING;
        end else begin
          next_state = STATE_SHIFT_DELAY;
        end
      end

      STATE_COUNTING: begin
        if (delay_countdown == 4'd0 && cycle_count == 10'd999) begin
          next_state = STATE_DONE;
        end else begin
          next_state = STATE_COUNTING;
        end
      end

      STATE_DONE: begin
        if (ack) begin
          next_state = STATE_SEARCH;
        end else begin
          next_state = STATE_DONE;
        end
      end

      default: next_state = STATE_SEARCH;
    endcase
  end

  // delay_countdown load when entering COUNTING state
  // Because delay is loaded bit by bit MSB first, delay register is ready after SHIFT_DELAY
  // Load delay_countdown with delay once entering COUNTING
  reg entered_counting;
  always @(posedge clk) begin
    if (reset) begin
      entered_counting <= 1'b0;
    end else if (state != STATE_COUNTING && next_state == STATE_COUNTING) begin
      entered_counting <= 1'b1;
      delay_countdown <= delay;
      cycle_count <= 10'd0;
    end else begin
      entered_counting <= 1'b0;
    end
  end

endmodule