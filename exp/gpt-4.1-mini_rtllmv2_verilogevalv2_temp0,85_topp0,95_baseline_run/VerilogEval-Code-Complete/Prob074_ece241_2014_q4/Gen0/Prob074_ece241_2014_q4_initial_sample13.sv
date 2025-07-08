module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  wire d0, d1, d2;
  wire q0_bar, q1_bar, q2_bar;

  // Complemented outputs
  assign q0_bar = ~q0;
  assign q1_bar = ~q1;
  assign q2_bar = ~q2;

  // D inputs to flip-flops
  // d0 = x XOR q0
  assign d0 = x ^ q0;
  // d1 = x AND q1_bar
  assign d1 = x & q1_bar;
  // d2 = x OR q2_bar
  assign d2 = x | q2_bar;

  // Flip-flops with synchronous reset to zero
  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // Output z is NOR of q0, q1, q2
  assign z = ~(q0 | q1 | q2);

endmodule