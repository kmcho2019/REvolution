module TopModule (
  input clk,
  input in,
  output reg out
);

reg d_ff;

always @(posedge clk) begin
    d_ff <= in ^ out;
    out <= d_ff;
end

endmodule