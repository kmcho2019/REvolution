module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  wire d0, d1, d2;

  // D inputs based on the description
  assign d0 = x ^ q0;       // XOR with own output
  assign d1 = x & ~q1;      // AND with complement of own output
  assign d2 = x | ~q2;      // OR with complement of own output

  // Flip-flops with synchronous reset to zero at start
  initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
  end

  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // NOR of the three flip-flop outputs
  assign z = ~(q0 | q1 | q2);

endmodule