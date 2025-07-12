module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

assign result = A - B;
assign overflow = (A[63]^B[63]) & (A[63]^result[63]);

endmodule