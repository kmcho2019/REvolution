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
    SEARCH   = 2'd0,
    SHIFT    = 2'd1,
    COUNTING = 2'd2,
    DONE     = 2'd3
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_reg;    // to detect pattern 1101
  reg [1:0] shift_count;  // counts 4 clock cycles in SHIFT state

  // Sequential logic: state and shift register updates
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0;
      shift_count <= 2'b0;
    end else begin
      state <= next_state;

      if (state == SEARCH) begin
        // shift in new bit
        shift_reg <= {shift_reg[2:0], data};
      end

      if (state == SHIFT) begin
        shift_count <= shift_count + 2'd1;
      end else begin
        shift_count <= 2'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    // default next state
    next_state = state;

    case (state)
      SEARCH: begin
        // Detect pattern 1101
        if (shift_reg == 4'b1101) begin
          next_state = SHIFT;
        end
      end

      SHIFT: begin
        if (shift_count == 2'd3) begin
          // after 4 cycles (0 to 3)
          next_state = COUNTING;
        end
      end

      COUNTING: begin
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
    // default outputs
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
      SHIFT: shift_ena = 1;
      COUNTING: counting = 1;
      DONE: done = 1;
    endcase
  end

endmodule