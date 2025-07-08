module TopModule (
  input clk,
  input x,
  output z
);

  reg q0, q1, q2;

  // Initialize flip-flops to zero on start (synthesis tools typically add reset logic)
  initial begin
    q0 = 1'b0;
    q1 = 1'b0;
    q2 = 1'b0;
  end

  wire d0, d1, d2;

  assign d0 = x ^ q0;       // XOR gate input to first flip-flop
  assign d1 = x & (~q1);    // AND gate input to second flip-flop
  assign d2 = x | (~q2);    // OR gate input to third flip-flop

  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  assign z = ~(q0 | q1 | q2);  // 3-input NOR gate output

endmodule