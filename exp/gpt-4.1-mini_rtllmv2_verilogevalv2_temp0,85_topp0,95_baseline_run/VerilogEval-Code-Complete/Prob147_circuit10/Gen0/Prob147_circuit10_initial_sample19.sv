module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  reg state_reg;

  assign state = state_reg;

  always @(posedge clk) begin
    q <= (~state_reg & b) | (~a & state_reg);
    state_reg <= q;
  end

endmodule