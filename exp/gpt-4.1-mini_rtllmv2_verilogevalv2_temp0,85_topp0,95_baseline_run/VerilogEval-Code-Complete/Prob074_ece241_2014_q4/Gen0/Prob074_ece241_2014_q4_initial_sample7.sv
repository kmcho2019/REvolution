module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  // Initial reset to zero
  initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
  end

  wire d0, d1, d2;

  // Compute D inputs according to problem description
  assign d0 = x ^ q0;     // XOR with own output
  assign d1 = x & (~q1);  // AND with complement of own output
  assign d2 = x | (~q2);  // OR with complement of own output

  // Flip-flops triggered on rising edge of clk
  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // Output is NOR of all three flip-flop outputs
  assign z = ~(q0 | q1 | q2);

endmodule