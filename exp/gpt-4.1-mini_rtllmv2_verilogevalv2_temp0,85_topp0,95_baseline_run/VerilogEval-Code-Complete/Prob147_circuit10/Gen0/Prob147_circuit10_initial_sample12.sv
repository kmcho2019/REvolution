module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  reg state_reg;

  wire next_state;

  assign next_state = (~state_reg & (a | b)) | (state_reg & ((a & b) | (~a & ~b)));

  always @(posedge clk) begin
    state_reg <= next_state;
    q <= next_state;
  end

  assign state = state_reg;

endmodule