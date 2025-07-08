module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

  // State encoding
  typedef enum logic [1:0] {
    SEARCH = 2'b00,
    SHIFT  = 2'b01,
    COUNT  = 2'b10,
    DONE   = 2'b11
  } state_t;

  state_t state, next_state;

  // 4-bit shift register to detect pattern 1101
  reg [3:0] pattern_shift;

  // Counter for shift_ena duration (4 cycles)
  reg [2:0] shift_count; // 3 bits enough for 4 counts

  // Pattern to detect
  localparam [3:0] PATTERN = 4'b1101;

  // Sequential block: state register, pattern shift register, shift_count
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      if (state == SEARCH) begin
        // Shift in data bit
        pattern_shift <= {pattern_shift[2:0], data};
      end else begin
        // Hold pattern_shift in other states
        pattern_shift <= pattern_shift;
      end

      if (state == SHIFT) begin
        shift_count <= shift_count + 1;
      end else begin
        shift_count <= 3'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case(state)
      SEARCH: begin
        if (pattern_shift == PATTERN) begin
          next_state = SHIFT;
        end
      end

      SHIFT: begin
        if (shift_count == 3'd3) begin // after 4 cycles (0 to 3)
          next_state = COUNT;
        end
      end

      COUNT: begin
        if (done_counting) begin
          next_state = DONE;
        end
      end

      DONE: begin
        if (ack) begin
          next_state = SEARCH;
        end
      end

      default: next_state = SEARCH;
    endcase
  end

  // Output logic
  always @(*) begin
    // Defaults
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case(state)
      SHIFT: begin
        shift_ena = 1'b1;
      end
      COUNT: begin
        counting = 1'b1;
      end
      DONE: begin
        done = 1'b1;
      end
    endcase
  end

endmodule