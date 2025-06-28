module TopModule (
  input clk,
  input d,
  output reg q
);

reg latch;

always @(posedge clk or negedge clk) begin
  latch <= d;
end

always @(posedge clk) begin
  q <= latch;
end

endmodule