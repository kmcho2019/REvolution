module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;

// First D flip-flop triggered on positive edge
always @(posedge clk)
  q1 <= d;

// Second D flip-flop triggered on negative edge of the original clock
always @(negedge clk)
  q2 <= q1;

// Output q is updated on the negative edge of the clock or the positive edge of the inverted clock
assign q = q2;

endmodule