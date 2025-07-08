module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam S0 = 1'b0; // before first '1' found
  localparam S1 = 1'b1; // after first '1' found

  reg state, next_state;
  reg x_reg; // stores input bit from previous cycle

  // Asynchronous reset and state & x_reg update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S0;
      x_reg <= 1'b0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      x_reg <= x;
      // Output z is updated based on next_state and stored input bit (x_reg)
      // But since Moore output depends on current state,
      // we output based on current state and x_reg (previous input)
      case (state)
        S0: z <= x_reg;     // before first '1', output same bit as input
        S1: z <= ~x_reg;    // after first '1', output inverted bit
        default: z <= 1'b0;
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S0: begin
        if (x == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        next_state = S1;
      end
      default: next_state = S0;
    endcase
  end

endmodule