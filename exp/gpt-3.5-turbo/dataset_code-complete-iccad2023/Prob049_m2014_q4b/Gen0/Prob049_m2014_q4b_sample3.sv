module d_ff_ar (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or negedge ar) begin
  if (!ar) begin
    q <= 0;
  end else begin
    q <= d;
  end
end

endmodule