module TopModule (
  input clk,
  input a,
  input b,
  output q,
  output state
);

  reg q_reg;

  wire next_state;
  // Deriving next state from inputs and current state
  assign next_state = (~a & b) | (~q_reg & a & ~b);

  always @(posedge clk) begin
    q_reg <= next_state;
  end

  assign q = q_reg;
  assign state = q_reg;

endmodule