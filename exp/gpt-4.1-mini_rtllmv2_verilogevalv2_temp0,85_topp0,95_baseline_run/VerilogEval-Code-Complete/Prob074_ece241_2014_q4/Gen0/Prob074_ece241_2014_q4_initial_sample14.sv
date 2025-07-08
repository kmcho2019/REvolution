module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  // D inputs calculated from x and current Q outputs
  wire d0 = x ^ q0;
  wire d1 = x & ~q1;
  wire d2 = x | ~q2;

  // Sequential logic: D flip-flops with initial reset to zero
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

  // Output z is NOR of q0, q1, q2
  assign z = ~(q0 | q1 | q2);

endmodule