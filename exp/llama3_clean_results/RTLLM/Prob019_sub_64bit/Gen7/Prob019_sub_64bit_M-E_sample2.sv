// Module for 64-bit subtraction
module sub_64bit_core (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result
);

    assign result = A - B;

endmodule

// Module for overflow detection
module overflow_detector (
    input   [63:0] A,
    input   [63:0] B,
    input   [63:0] result,
    output         overflow
);

    // Check if A and B have different signs and the result has a different sign than A
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule

// Top-level module
module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [63:0] internal_result;

    // Instantiate the subtraction core
    sub_64bit_core u_sub (
        .A(A),
        .B(B),
        .result(internal_result)
    );

    // Instantiate the overflow detector
    overflow_detector u_overflow (
        .A(A),
        .B(B),
        .result(internal_result),
        .overflow(overflow)
    );

    // Assign the internal result to the output
    assign result = internal_result;

endmodule