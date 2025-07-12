module TopModule(
    input x,
    input y,
    output z
);

wire xor_result;
assign xor_result = x ^ y;
assign z = x ? xor_result : 1'b0;

endmodule