module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [63:0] abs_A, abs_B, abs_diff;
    wire        A_sign, B_sign, result_sign;

    // Calculate absolute values of A and B
    assign abs_A = A[63] ? -A : A;
    assign abs_B = B[63] ? -B : B;

    // Perform subtraction on absolute values
    assign abs_diff = abs_A - abs_B;

    // Determine signs of A, B, and result
    assign A_sign = A[63];
    assign B_sign = B[63];
    assign result_sign = abs_diff[63];

    // Apply sign adjustments and detect overflow
    assign result = (A_sign == B_sign) ? abs_diff : (A_sign ? -abs_diff : abs_diff);
    assign overflow = (A_sign != B_sign) && (A_sign == result_sign);

endmodule