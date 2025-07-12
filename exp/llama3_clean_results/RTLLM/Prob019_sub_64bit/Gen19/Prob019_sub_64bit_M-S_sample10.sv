module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    assign result = A - B;
    assign overflow = (A[63] == B[63] && A[63] != result[63]) ? 1'b1 : 1'b0;

endmodule