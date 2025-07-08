module TopModule (
  input clk,
  input a,
  input b,
  output q,
  output state
);

  reg state_reg;

  // Next state logic
  wire next_state;
  assign next_state = (a & ~b) | (state_reg & ~(a ^ b));

  // State flip-flop
  always @(posedge clk) begin
    state_reg <= next_state;
  end

  // Outputs
  assign state = state_reg;
  assign q = state_reg;

endmodule