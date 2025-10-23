module TopModule(clk, d, r, q);
  input clk, d, r;
  output reg q;
  always @(posedge clk)
    if (r) q <= 0; else q <= d;
endmodule