module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  initial q = 1'b1; // Initialize output to 1

  always @(posedge clk)
    if (a == 1'b0) // If a is 0, set q to 1
      q <= 1'b1;
    else if (a == 1'b1) // If a is 1, toggle q
      q <= ~q;
endmodule