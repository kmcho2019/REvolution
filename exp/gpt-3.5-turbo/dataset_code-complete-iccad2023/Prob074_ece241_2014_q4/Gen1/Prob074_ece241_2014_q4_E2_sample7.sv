module TopModule (
  input clk,
  input x,
  output z
);

reg [2:0] d_ff;
wire xor_out, and_out, or_out;

assign xor_out = x ^ d_ff[0];
assign and_out = x & ~d_ff[1];
assign or_out = x | ~d_ff[2];

always @(posedge clk) begin
  d_ff <= {xor_out, and_out, or_out};
end

assign z = ~(d_ff[0] | d_ff[1] | d_ff[2]);

endmodule