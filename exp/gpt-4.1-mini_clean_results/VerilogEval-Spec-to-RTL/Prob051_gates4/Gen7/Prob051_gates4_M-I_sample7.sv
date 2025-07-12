module TopModule(input [3:0] in, output out_and, out_or, out_xor);

wire and_res = &in;
wire or_res  = |in;
wire xor_res = ^in;

assign out_and = and_res;
assign out_or  = or_res;
assign out_xor = xor_res;

endmodule