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
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    DONE = 2'b11
  } state_t;
  state_t state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] pattern_shift;

  // Counter for shift cycles (4 cycles)
  reg [2:0] shift_count; // 3 bits to count up to 4

  // Pattern to detect: 4'b1101
  localparam [3:0] PATTERN = 4'b1101;

  // Pattern detection on each clock cycle in IDLE
  always @(posedge clk) begin
    if (reset) begin
      pattern_shift <= 4'b0000;
    end else if (state == IDLE) begin
      pattern_shift <= {pattern_shift[2:0], data};
    end
  end

  // FSM state register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // shift_count register
  always @(posedge clk) begin
    if (reset) begin
      shift_count <= 3'd0;
    end else if (state == SHIFT) begin
      if (shift_count < 3'd4)
        shift_count <= shift_count + 1;
    end else begin
      shift_count <= 3'd0;
    end
  end

  // Next state logic
  always @(*) begin
    // Defaults
    next_state = state;
    case(state)
      IDLE: begin
        if (pattern_shift == PATTERN)
          next_state = SHIFT;
      end
      SHIFT: begin
        if (shift_count == 3'd4)
          next_state = COUNT;
      end
      COUNT: begin
        if (done_counting)
          next_state = DONE;
      end
      DONE: begin
        if (ack)
          next_state = IDLE;
      end
    endcase
  end

  // Output logic
  always @(*) begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case(state)
      SHIFT: shift_ena = 1'b1;
      COUNT: counting = 1'b1;
      DONE:  done = 1'b1;
    endcase
  end

endmodule