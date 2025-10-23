module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg next_Q;

  always @(L or q_in or r_in)
    next_Q = L? r_in : q_in;

  always @(posedge clk)
    Q <= next_Q;

endmodule