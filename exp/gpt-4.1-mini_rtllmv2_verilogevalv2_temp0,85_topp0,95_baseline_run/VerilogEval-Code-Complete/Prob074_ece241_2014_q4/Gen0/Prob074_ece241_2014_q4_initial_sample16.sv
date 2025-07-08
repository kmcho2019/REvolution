module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  // Synchronous reset to zero on initial block
  initial begin
    q0 = 1'b0;
    q1 = 1'b0;
    q2 = 1'b0;
  end

  wire d0, d1, d2;

  // Compute D inputs
  assign d0 = x ^ q0;       // XOR with q0
  assign d1 = x & ~q1;      // AND with complement of q1
  assign d2 = x | ~q2;      // OR with complement of q2

  // Flip-flops update at posedge clk
  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // Output z is NOR of q0, q1, q2
  assign z = ~(q0 | q1 | q2);

endmodule