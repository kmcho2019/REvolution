module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    logic [63:0] temp_result;
    assign temp_result = A - B;
    assign result = temp_result;
    assign overflow = (A[63] == B[63] && A[63] != result[63]) ? 1'b1 : 1'b0;

endmodule