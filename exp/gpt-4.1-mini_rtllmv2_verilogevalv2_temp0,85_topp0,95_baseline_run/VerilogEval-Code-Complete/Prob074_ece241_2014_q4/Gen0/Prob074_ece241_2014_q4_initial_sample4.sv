module TopModule (
  input clk,
  input x,
  output z
);
  reg q0, q1, q2;

  // D inputs for flip-flops
  wire d0, d1, d2;

  // Combinational logic for D inputs
  assign d0 = x ^ q0;
  assign d1 = x & (~q1);
  assign d2 = x | (~q2);

  // Flip-flops with synchronous reset to 0 at start (assuming reset at simulation init)
  always @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
  end

  // NOR of q0, q1, q2 to produce z
  assign z = ~(q0 | q1 | q2);

endmodule