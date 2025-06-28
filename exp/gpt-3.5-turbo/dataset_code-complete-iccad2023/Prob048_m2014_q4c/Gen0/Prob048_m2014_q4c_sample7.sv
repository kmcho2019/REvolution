module DFF_with_reset (
  input clk,
  input d,
  input r,
  output reg q
);

always @(posedge clk) begin
  if (r == 1'b1) begin
    q <= 1'b0; // reset
  end else begin
    q <= d; // D input
  end
end

endmodule