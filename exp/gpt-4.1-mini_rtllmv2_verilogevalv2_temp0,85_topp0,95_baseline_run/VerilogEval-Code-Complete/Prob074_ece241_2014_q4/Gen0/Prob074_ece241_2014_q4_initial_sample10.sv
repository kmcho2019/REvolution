module TopModule (
  input clk,
  input x,
  output z
);
  reg q0, q1, q2;

  wire d0, d1, d2;

  // XOR gate: x and q0
  assign d0 = x ^ q0;

  // AND gate: x and ~q1
  assign d1 = x & (~q1);

  // OR gate: x or ~q2
  assign d2 = x | (~q2);

  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // Output z is NOR of q0, q1, q2
  assign z = ~(q0 | q1 | q2);

  // Initialize flip-flops to zero at start (synthesis may infer reset or initial block)
  initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
  end

endmodule