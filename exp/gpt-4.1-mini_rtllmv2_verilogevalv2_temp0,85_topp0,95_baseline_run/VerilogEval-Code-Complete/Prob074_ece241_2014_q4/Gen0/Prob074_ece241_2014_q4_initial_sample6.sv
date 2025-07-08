module TopModule (
  input clk,
  input x,
  output z
);
  reg ff1, ff2, ff3;

  wire d1, d2, d3;

  // D inputs based on gates and flip-flop outputs
  assign d1 = x ^ ff1;
  assign d2 = x & (~ff2);
  assign d3 = x | (~ff3);

  // Flip-flops with synchronous reset to zero at initial start
  initial begin
    ff1 = 0;
    ff2 = 0;
    ff3 = 0;
  end

  always @(posedge clk) begin
    ff1 <= d1;
    ff2 <= d2;
    ff3 <= d3;
  end

  // Output z is NOR of all three flip-flop outputs
  assign z = ~(ff1 | ff2 | ff3);

endmodule