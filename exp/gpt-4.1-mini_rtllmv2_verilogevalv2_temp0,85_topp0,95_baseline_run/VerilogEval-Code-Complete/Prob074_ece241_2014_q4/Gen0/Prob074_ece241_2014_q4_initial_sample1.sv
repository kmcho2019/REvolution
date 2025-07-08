module TopModule (
  input clk,
  input x,
  output z
);

  reg q1, q2, q3;

  // Synchronous reset to zero at start assumed by initial block
  initial begin
    q1 = 0;
    q2 = 0;
    q3 = 0;
  end

  wire d1 = x ^ q1;
  wire d2 = x & (~q2);
  wire d3 = x | (~q3);

  always @(posedge clk) begin
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
  end

  assign z = ~(q1 | q2 | q3);

endmodule