module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  initial q = 1'b1; // Initialize q to 1

  always @(posedge clk) // Trigger on positive clock edge
    if (a) // If a is 1
      q <= 1'b0; // Set q to 0
    else // If a is 0
      q <= q; // Keep q unchanged

endmodule