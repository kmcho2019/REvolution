module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_latch, q_ff;

always @(*) begin
  q_latch = d; // Level-sensitive latch
end

always @(posedge clk or negedge clk) begin
  q_ff <= q_latch; // Single flip-flop to store and output data from the latch
end

assign q = q_ff;

endmodule