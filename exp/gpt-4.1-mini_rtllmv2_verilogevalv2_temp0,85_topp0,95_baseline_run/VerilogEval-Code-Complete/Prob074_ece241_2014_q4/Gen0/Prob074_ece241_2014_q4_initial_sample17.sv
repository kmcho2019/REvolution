module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  // Asynchronous reset: initialize to zero
  initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
  end

  wire d0, d1, d2;

  // D input for each flip-flop according to the problem
  // q0: XOR with q0 output
  assign d0 = x ^ q0;
  // q1: AND with q1 complemented output
  assign d1 = x & ~q1;
  // q2: OR with q2 complemented output
  assign d2 = x | ~q2;

  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // 3-input NOR gate for output z
  assign z = ~(q0 | q1 | q2);

endmodule