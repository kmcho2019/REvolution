module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1, q2;
reg clk_inv;

always @ (posedge clk) begin
  q1 <= d;
end

// Generate an inverted clock signal
always @ (posedge clk) begin
  clk_inv <= ~clk;
end

always @ (posedge clk_inv) begin
  q2 <= q1;
end

assign q = q2;

endmodule