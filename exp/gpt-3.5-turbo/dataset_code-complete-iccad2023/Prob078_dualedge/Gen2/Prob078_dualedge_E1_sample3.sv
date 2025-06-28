module TopModule (
  input clk,
  input d,
  output reg q
);

reg [1:0] q_latch;
reg clk_prev;

always @(posedge clk) begin
  if(~clk_prev) // Falling edge of the clock
    q_latch[0] <= d;
  clk_prev <= 1;
end

always @(negedge clk) begin
  if(clk_prev) // Rising edge of the clock
    q_latch[1] <= q_latch[0];
  clk_prev <= 0;
end

assign q = q_latch[1];

endmodule