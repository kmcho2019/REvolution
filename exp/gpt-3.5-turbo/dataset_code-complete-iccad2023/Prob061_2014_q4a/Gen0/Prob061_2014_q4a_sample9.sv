module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

reg D;

always @(posedge clk) begin
  if (L) begin
    D <= R;
  end else begin
    D <= E ? w : D;
  end
end

assign Q = D;

endmodule