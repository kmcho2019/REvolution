module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

wire sign_mismatch = A[63] ^ B[63];
wire result_sign = (A - B)[63];

assign result = A - B;
assign overflow = sign_mismatch & (result_sign ^ A[63]);

endmodule