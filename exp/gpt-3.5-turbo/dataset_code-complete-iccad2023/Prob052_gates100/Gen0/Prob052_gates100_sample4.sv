module TopModule (
  input [99:0] in,
  output out_and,
  output out_or,
  output out_xor
);

wire [99:0] and_result;
wire [99:0] or_result;
wire [99:0] xor_result;

assign out_and = and_result[0];
assign out_or = or_result[0];
assign out_xor = xor_result[0];

assign and_result[0] = in[0];
assign or_result[0] = in[0];
assign xor_result[0] = in[0];

genvar i;
generate
  for (i = 1; i < 100; i = i + 1) begin : logic_loop
    assign and_result[i] = and_result[i-1] & in[i];
    assign or_result[i] = or_result[i-1] | in[i];
    assign xor_result[i] = xor_result[i-1] ^ in[i];
  end
endgenerate

endmodule