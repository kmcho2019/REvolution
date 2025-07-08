module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  // Next state logic
  wire d0 = x ^ q0;
  wire d1 = x & ~q1;
  wire d2 = x | ~q2;

  // Flip-flops with synchronous reset assumed initially zero (on power-up)
  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // Output is NOR of q0, q1, q2
  assign z = ~(q0 | q1 | q2);

endmodule