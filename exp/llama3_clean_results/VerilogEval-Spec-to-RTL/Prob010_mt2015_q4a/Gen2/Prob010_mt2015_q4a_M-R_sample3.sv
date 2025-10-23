module TopModule(
    input x,
    input y,
    output z
);

wire xor_result;
wire and_result;

assign xor_result = x ^ y;
assign and_result = xor_result & x;
assign z = and_result;

endmodule