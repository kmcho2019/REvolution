module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    // Overflow occurs when:
    // 1) A positive number minus a negative number yields a negative result (positive overflow)
    // 2) A negative number minus a positive number yields a positive result (negative overflow)
    assign overflow = (~sign_A & sign_B & sign_result) | (sign_A & ~sign_B & ~sign_result);

endmodule