module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Intermediate signals
    wire signed [63:0] difference;
    wire A_sign, B_sign, result_sign;
    wire signs_differ, result_sign_differs;

    // Perform the subtraction
    assign difference = A - B;
    assign result = difference;

    // Extract sign bits
    assign A_sign = A[63];
    assign B_sign = B[63];
    assign result_sign = result[63];

    // Overflow detection logic
    assign signs_differ = A_sign ^ B_sign;
    assign result_sign_differs = A_sign ^ result_sign;
    assign overflow = signs_differ & result_sign_differs;

endmodule