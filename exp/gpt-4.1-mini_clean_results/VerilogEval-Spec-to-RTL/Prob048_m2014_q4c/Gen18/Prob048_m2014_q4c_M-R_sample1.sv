module TopModule(clk, d, r, q);
  input clk, d, r;
  output reg q;

  wire next_q;
  assign next_q = r ? 1'b0 : d;

  always @(posedge clk)
    q <= next_q;
endmodule