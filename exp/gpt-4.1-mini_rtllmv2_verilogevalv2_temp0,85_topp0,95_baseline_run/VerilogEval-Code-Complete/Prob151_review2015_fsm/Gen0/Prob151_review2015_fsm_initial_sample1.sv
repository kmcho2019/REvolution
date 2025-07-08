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
  typedef enum reg [1:0] {
    SEARCH = 2'd0,
    SHIFT  = 2'd1,
    COUNT  = 2'd2,
    DONE   = 2'd3
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_reg;  // To detect pattern 1101
  reg [2:0] shift_count; // counts 4 shift cycles

  // Sequential: state and shift_reg update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0000;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      if (state == SEARCH) begin
        // Shift in new data bit
        shift_reg <= {shift_reg[2:0], data};
      end else if (state == SHIFT) begin
        // shift_count counts 4 cycles for shift_ena assertion
        shift_count <= shift_count + 1;
      end else begin
        // Clear shift_count outside SHIFT
        shift_count <= 3'd0;
      end
    end
  end

  // Combinational: next state logic and outputs
  always @(*) begin
    // Default outputs
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case (state)
      SEARCH: begin
        // Look for pattern 1101 in shift_reg
        if (shift_reg == 4'b1101) begin
          next_state = SHIFT;
        end
      end
      SHIFT: begin
        shift_ena = 1'b1;
        if (shift_count == 3'd3) begin
          // After 4 cycles (counting 0 to 3), move to COUNT
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
    endcase
  end

endmodule