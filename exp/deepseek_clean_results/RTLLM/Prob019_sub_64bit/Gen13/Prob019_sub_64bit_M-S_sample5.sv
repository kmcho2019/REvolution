module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output [63:0] result,
    output overflow
);

    // Behavioral subtraction (synthesis tool will optimize)
    assign result = A - B;

    // Optimal overflow detection
    wire operands_diff_sign = A[63] != B[63];
    wire result_diff_sign = A[63] != result[63];
    assign overflow = operands_diff_sign && result_diff_sign;

endmodule