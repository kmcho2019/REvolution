module DFF_with_reset (
  input clk,
  input d,
  input reset,
  output reg q
);

always @(posedge clk) begin
  if (reset) begin
    q <= 0;
  end else begin
    q <= d;
  end
end

endmodule