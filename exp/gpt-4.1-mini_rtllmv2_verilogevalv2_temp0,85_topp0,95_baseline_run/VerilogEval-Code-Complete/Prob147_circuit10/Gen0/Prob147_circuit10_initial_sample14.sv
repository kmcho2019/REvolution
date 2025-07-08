module TopModule (
  input clk,
  input a,
  input b,
  output q,
  output state
);

  reg state_reg;

  // Next state logic: state toggles if a ^ b is 1
  wire next_state = a ^ b ^ state_reg;

  always @(posedge clk) begin
    state_reg <= next_state;
  end

  assign state = state_reg;
  assign q = state_reg;

endmodule