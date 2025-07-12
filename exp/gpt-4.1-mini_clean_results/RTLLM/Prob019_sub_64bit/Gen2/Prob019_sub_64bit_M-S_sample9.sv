module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    assign result = A - B;
    assign overflow = (A[63] ^ B[63]) & (result[63] ^ A[63]);

endmodule