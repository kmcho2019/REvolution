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
    IDLE     = 2'b00,
    SHIFT    = 2'b01,
    COUNTING = 2'b10,
    DONE     = 2'b11
  } state_t;

  state_t state, next_state;

  reg [3:0] pattern_reg;    // shift register for pattern detection
  reg [2:0] shift_counter;  // counts 4 cycles in SHIFT state

  // Pattern detection: shift in data on each clock in IDLE state
  always @(posedge clk) begin
    if (reset) begin
      pattern_reg <= 4'b0000;
    end else if (state == IDLE) begin
      pattern_reg <= {pattern_reg[2:0], data};
    end
  end

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // shift_counter register
  always @(posedge clk) begin
    if (reset) begin
      shift_counter <= 3'd0;
    end else if (state == SHIFT) begin
      if (shift_counter < 3'd4)
        shift_counter <= shift_counter + 1;
    end else begin
      shift_counter <= 3'd0;
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        // Detect pattern 1101 in pattern_reg
        if (pattern_reg == 4'b1101)
          next_state = SHIFT;
      end
      SHIFT: begin
        if (shift_counter == 3'd4)
          next_state = COUNTING;
      end
      COUNTING: begin
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
    // Defaults
    shift_ena = 1'b0;
    counting  = 1'b0;
    done      = 1'b0;

    case(state)
      SHIFT: begin
        if (shift_counter < 3'd4)
          shift_ena = 1'b1;
      end
      COUNTING: counting = 1'b1;
      DONE: done = 1'b1;
    endcase
  end

endmodule