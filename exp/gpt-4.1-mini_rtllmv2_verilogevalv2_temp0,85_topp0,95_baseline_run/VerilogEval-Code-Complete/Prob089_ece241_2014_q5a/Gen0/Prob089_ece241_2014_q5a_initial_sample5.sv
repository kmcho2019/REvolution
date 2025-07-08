module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam S0 = 1'b0; // Copy bits until first '1' found
  localparam S1 = 1'b1; // Invert bits after first '1'

  reg state, next_state;

  // State transition with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      S0: next_state = (x == 1'b1) ? S1 : S0;
      S1: next_state = S1;
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore output)
  always @(posedge clk or posedge areset) begin
    if (areset)
      z <= 1'b0;
    else begin
      case(state)
        S0: z <= x;
        S1: z <= ~x;
        default: z <= 1'b0;
      endcase
    end
  end

endmodule