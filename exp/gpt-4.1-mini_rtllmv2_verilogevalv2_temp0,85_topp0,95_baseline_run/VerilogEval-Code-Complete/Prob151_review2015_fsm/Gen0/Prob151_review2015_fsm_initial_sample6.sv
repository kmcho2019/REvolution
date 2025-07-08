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

  state_t state, next_state;

  reg [3:0] shift_reg;       // To detect pattern 1101
  reg [2:0] shift_count;     // Counts the 4 shift cycles

  // Synchronous reset and state register
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0000;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      // Shift in data to detect pattern only in SEARCH state
      if (state == SEARCH) begin
        shift_reg <= {shift_reg[2:0], data};
      end

      // Count shift cycles in SHIFT state
      if (state == SHIFT) begin
        shift_count <= shift_count + 1;
      end else begin
        shift_count <= 0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Default outputs
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case(state)
      SEARCH: begin
        // Wait for pattern 1101 on shift_reg
        if (shift_reg == 4'b1101) begin
          next_state = SHIFT;
        end
      end

      SHIFT: begin
        shift_ena = 1'b1;
        // After 4 shift cycles, go to COUNT
        if (shift_count == 3'd4) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        counting = 1'b1;
        if (done_counting) begin
          next_state = DONE;
        end
      end

      DONE: begin
        done = 1'b1;
        if (ack) begin
          next_state = SEARCH;
        end
      end

      default: next_state = SEARCH;
    endcase
  end

endmodule