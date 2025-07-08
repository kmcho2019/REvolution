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
  // FSM states
  typedef enum reg [2:0] {
    SEARCH = 3'd0,
    SHIFT  = 3'd1,
    COUNT  = 3'd2,
    DONE   = 3'd3
  } state_t;

  reg [2:0] state, next_state;

  // Shift register for pattern detection
  reg [3:0] pattern_shift;

  // Counter for 4 shift cycles in SHIFT state
  reg [2:0] shift_count;

  // Synchronous state register update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      // Shift in new data bit for pattern detection only in SEARCH state
      if (state == SEARCH) begin
        pattern_shift <= {pattern_shift[2:0], data};
      end

      // Count shift cycles in SHIFT state
      if (state == SHIFT) begin
        shift_count <= shift_count + 1;
      end else begin
        shift_count <= 3'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Defaults
    next_state = state;

    case (state)
      SEARCH: begin
        // Check for pattern 1101
        // pattern_shift includes the 4 last bits shifted in
        // After shifting in data, pattern_shift is valid
        if (pattern_shift == 4'b1101)
          next_state = SHIFT;
      end
      SHIFT: begin
        // After 4 shift cycles, move to COUNT
        if (shift_count == 3'd3) // counting from 0 to 3 (4 cycles)
          next_state = COUNT;
      end
      COUNT: begin
        if (done_counting)
          next_state = DONE;
      end
      DONE: begin
        if (ack)
          next_state = SEARCH;
      end
      default: next_state = SEARCH;
    endcase
  end

  // Output logic
  always @(*) begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case (state)
      SHIFT: shift_ena = 1'b1;
      COUNT: counting = 1'b1;
      DONE: done = 1'b1;
    endcase
  end

endmodule