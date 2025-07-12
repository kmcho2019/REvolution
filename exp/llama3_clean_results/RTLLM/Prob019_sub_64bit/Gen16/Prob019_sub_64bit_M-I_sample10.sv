module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    assign result = $signed(A) - $signed(B);
    assign overflow = ((A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) || 
                      (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0));

endmodule