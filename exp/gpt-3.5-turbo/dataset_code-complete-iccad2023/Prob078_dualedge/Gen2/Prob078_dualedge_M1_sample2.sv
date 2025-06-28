module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;
wire intermediate_value;

// First D flip-flop triggered on positive clock edge
always @(posedge clk)
  q1 <= d;

// Level-sensitive latch to capture intermediate value
assign intermediate_value = q1;

// Second D flip-flop triggered on negative clock edge
always @(negedge clk)
  q2 <= intermediate_value;

assign q = q2;

endmodule