module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    assign result = A - B;
    assign overflow = (A[63] == 1 && B[63] == 0 && result[63] == 0) || (A[63] == 0 && B[63] == 1 && result[63] == 1);

endmodule