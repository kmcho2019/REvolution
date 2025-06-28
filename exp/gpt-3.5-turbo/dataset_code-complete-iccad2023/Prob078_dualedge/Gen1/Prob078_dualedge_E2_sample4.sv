module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;
reg data_latch;

always @(posedge clk or negedge clk) begin
  if (~clk) begin
    // Level-sensitive latch to store input data temporarily
    data_latch <= d;
  end
  else begin
    // Update flip-flop output on both rising and falling edges
    q1 <= data_latch;
    q2 <= q1;
  end
end

assign q = q2;

endmodule