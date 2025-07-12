module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  always @(posedge clk)
    if (!a) q <= 1;
    else q <= 0;

endmodule