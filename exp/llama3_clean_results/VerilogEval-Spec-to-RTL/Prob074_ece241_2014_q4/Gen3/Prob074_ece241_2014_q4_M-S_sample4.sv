module TopModule(
  input clk,
  input x,
  output z
);

  // Define the states of the flip-flops
  reg q0, q1, q2;

  // Combinational logic
  assign d0 = x ^ q0;
  assign d1 = x & ~q1;
  assign d2 = x | ~q2;

  // Sequential logic
  always @(posedge clk) begin
    q0 <= #1 d0;
    q1 <= #1 d1;
    q2 <= #1 d2;
  end

  // Output logic
  assign z = ~(q0 | q1 | q2);

endmodule