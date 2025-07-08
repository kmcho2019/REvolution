module TopModule (
  input clk,
  input x,
  output z
);

  reg q1, q2, q3;

  wire d1, d2, d3;

  // Calculate D inputs according to the problem statement
  assign d1 = x ^ q1;
  assign d2 = x & ~q2;
  assign d3 = x | ~q3;

  // Flip-flops with asynchronous reset to zero at start (initial block)
  initial begin
    q1 = 0;
    q2 = 0;
    q3 = 0;
  end

  always @(posedge clk) begin
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
  end

  // Output Z is NOR of q1, q2, q3
  assign z = ~(q1 | q2 | q3);

endmodule