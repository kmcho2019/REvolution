module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state, next_state;

  // Asynchronous reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B; // reset to state B
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      B: next_state = (in == 1'b0) ? A : B;
      A: next_state = (in == 1'b0) ? B : A;
      default: next_state = B;
    endcase
  end

  // Output logic (Moore machine)
  always @(*) begin
    case(state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b0;
    endcase
  end

endmodule