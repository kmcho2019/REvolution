module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire xor0, xor1, or_xor;

assign xor0 = A[0] ^ B[0];
assign xor1 = A[1] ^ B[1];
assign or_xor = xor0 | xor1;
assign z = ~or_xor;

endmodule