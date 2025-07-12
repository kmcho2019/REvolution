module TopModule (
    input clk,
    input L,
    input q_in,  // Input from the load path
    input r_in,  // Input from the internal logic path
    output Q
);

reg q;

always @(posedge clk) begin
  if (L) begin
    q <= q_in;
  end else begin
    q <= r_in;
  end
end

assign Q = q;

endmodule