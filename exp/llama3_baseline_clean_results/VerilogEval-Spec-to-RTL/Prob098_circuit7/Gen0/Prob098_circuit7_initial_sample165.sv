module TopModule(clk, a, q);
  input clk, a;
  output q;
  reg q;

  initial q = 1;

  always @(posedge clk)
    if (a == 0 && q == 1)
      q <= 1;
    else if (a == 1)
      q <= 0;
    else
      q <= 1;

endmodule