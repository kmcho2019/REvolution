module TopModule (
  input clk,
  input x,
  output z
);

  reg q1, q2, q3;

  // Asynchronous reset to zero at start (initial block for simulation)
  initial begin
    q1 = 0;
    q2 = 0;
    q3 = 0;
  end

  wire d1, d2, d3;

  // Compute D inputs
  assign d1 = x ^ q1;
  assign d2 = x & (~q2);
  assign d3 = x | (~q3);

  // Flip-flops update on rising edge of clk
  always @(posedge clk) begin
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
  end

  // NOR of q1, q2, q3
  assign z = ~(q1 | q2 | q3);

endmodule