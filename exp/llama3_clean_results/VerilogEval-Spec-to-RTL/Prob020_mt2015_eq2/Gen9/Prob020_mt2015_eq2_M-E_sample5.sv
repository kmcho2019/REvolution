module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

wire xor_result_1;
wire xor_result_0;

assign xor_result_1 = A[1] ^ B[1];
assign xor_result_0 = A[0] ^ B[0];

assign z = ~(xor_result_1 | xor_result_0);

endmodule