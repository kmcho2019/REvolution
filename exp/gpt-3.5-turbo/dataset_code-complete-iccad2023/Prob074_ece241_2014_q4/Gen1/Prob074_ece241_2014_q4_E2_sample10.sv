module TopModule (
  input clk,
  input x,
  output reg z
);

reg d_ff [2:0];
wire xor_out, and_out, or_out;

assign xor_out = x ^ d_ff[0];
assign and_out = x & ~d_ff[1];
assign or_out = x | ~d_ff[2];

assign z = ~(xor_out | and_out | or_out);

always @(posedge clk) begin
  d_ff <= {xor_out, and_out, or_out};
end

endmodule