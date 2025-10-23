module TopModule(clk, d, q);
  input clk;
  input d;
  output q;
  reg q; // 'q' is a reg because it needs to be assigned within a procedural block

  always @(posedge clk) // Triggers on the positive edge of the clock
    q <= d; // Assign the value of 'd' to 'q' at the positive edge

endmodule