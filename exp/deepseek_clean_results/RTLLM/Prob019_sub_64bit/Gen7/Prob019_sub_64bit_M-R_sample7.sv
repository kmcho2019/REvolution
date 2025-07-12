module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform the subtraction
    wire [63:0] subtraction_result = A - B;
    
    // Overflow detection logic
    wire operands_diff_sign = A[63] != B[63];
    wire result_diff_sign = A[63] != subtraction_result[63];
    wire overflow_condition = operands_diff_sign && result_diff_sign;

    // Assign outputs
    assign result = subtraction_result;
    assign overflow = overflow_condition;

endmodule