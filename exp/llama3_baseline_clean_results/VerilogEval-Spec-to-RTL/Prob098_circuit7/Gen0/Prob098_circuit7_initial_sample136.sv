module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  initial q = 1'b1;
  always @(posedge clk)
    if (a)
      q <= ~q;
    else
      q <= q;

endmodule