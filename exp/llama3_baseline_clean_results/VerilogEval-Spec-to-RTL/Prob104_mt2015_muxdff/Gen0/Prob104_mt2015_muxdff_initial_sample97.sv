module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

reg state;

always @(posedge clk) begin
  if (L) begin
    state <= r_in;
  end else begin
    state <= q_in;
  end
end

assign Q = state;

endmodule