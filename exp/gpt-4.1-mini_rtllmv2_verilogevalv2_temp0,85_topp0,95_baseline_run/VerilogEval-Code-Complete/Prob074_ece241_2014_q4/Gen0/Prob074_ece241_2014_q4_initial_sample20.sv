module TopModule (
  input clk,
  input x,
  output z
);

  reg q1, q2, q3;

  // Next state logic
  wire d1 = x ^ q1;
  wire d2 = x & ~q2;
  wire d3 = x | ~q3;

  // Flip-flops with synchronous reset to 0 at start (initial block)
  initial begin
    q1 = 0;
    q2 = 0;
    q3 = 0;
  end

  always @(posedge clk) begin
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
  end

  assign z = ~(q1 | q2 | q3);

endmodule