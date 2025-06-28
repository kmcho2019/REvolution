module TopModule (
  input clk,
  input x,
  output z
);

reg [2:0] d_ff;
wire d_ff_out_xor, d_ff_out_and, d_ff_out_or;

assign d_ff_out_xor = x ^ d_ff[0];
assign d_ff_out_and = x & ~d_ff[1];
assign d_ff_out_or = x | ~d_ff[2];

assign z = ~(d_ff_out_xor | d_ff_out_and | d_ff_out_or);

always @(posedge clk) begin
  d_ff <= {d_ff_out_xor, d_ff_out_and, d_ff_out_or};
end

endmodule