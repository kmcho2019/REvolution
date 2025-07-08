module TopModule (
  input clk,
  input x,
  output z
);

  reg q1, q2, q3;

  wire d1, d2, d3;

  // Compute D inputs for each flip-flop
  assign d1 = x ^ q1;      // XOR with Q1
  assign d2 = x & ~q2;     // AND with complement of Q2
  assign d3 = x | ~q3;     // OR with complement of Q3

  // Output is NOR of q1, q2, q3
  assign z = ~(q1 | q2 | q3);

  // Synchronous reset to zero assumed at start (initial block)
  initial begin
    q1 = 1'b0;
    q2 = 1'b0;
    q3 = 1'b0;
  end

  // Flip-flops: update on rising edge of clk
  always @(posedge clk) begin
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
  end

endmodule