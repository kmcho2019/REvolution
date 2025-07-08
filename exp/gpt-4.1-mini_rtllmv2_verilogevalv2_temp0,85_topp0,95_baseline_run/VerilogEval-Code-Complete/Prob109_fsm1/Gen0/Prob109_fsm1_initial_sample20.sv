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

  // State register with async reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      B: next_state = (in == 1'b0) ? A : B;
      A: next_state = (in == 1'b0) ? B : A;
      default: next_state = B; // default to B for safety
    endcase
  end

  // Output logic (Moore machine: output depends only on state)
  always @(*) begin
    case(state)
      A: out = 1'b0;
      B: out = 1'b1;
      default: out = 1'b1;
    endcase
  end

endmodule