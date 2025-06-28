module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_delayed;

always @ (posedge clk or negedge clk) begin
  q_delayed <= q;
  if (clk != q_delayed) // Detecting both rising and falling edges
    q <= d;
end

endmodule