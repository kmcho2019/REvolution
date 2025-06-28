module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;

// First D flip-flop triggered on the positive edge of the clock
always @(posedge clk)
  q1 <= d;

// Second D flip-flop triggered on the positive edge of the clock with a delay
always @(posedge clk)
  q2 <= q1;

assign q = q2;

endmodule