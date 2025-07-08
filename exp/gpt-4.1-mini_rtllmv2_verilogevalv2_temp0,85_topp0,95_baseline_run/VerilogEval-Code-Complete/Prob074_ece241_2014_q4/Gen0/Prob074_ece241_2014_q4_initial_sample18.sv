module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  wire d0, d1, d2;

  // D inputs based on the problem statement
  assign d0 = x ^ q0;
  assign d1 = x & ~q1;
  assign d2 = x | ~q2;

  // Flip-flops with asynchronous reset initialized to 0 at start
  initial begin
    q0 = 1'b0;
    q1 = 1'b0;
    q2 = 1'b0;
  end

  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // 3-input NOR gate for output z
  assign z = ~(q0 | q1 | q2);

endmodule