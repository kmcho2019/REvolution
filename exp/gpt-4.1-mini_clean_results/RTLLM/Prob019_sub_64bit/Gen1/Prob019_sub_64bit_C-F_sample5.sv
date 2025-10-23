module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction: result = A - B
    assign result = A - B;

    // Extract sign bits of operands and result
    wire sign_A   = A[63];
    wire sign_B   = B[63];
    wire sign_res = result[63];

    // Overflow detection logic:
    // Positive overflow occurs if A is positive (0), B is negative (1), but result is negative (1)
    wire pos_overflow = (~sign_A) & sign_B & sign_res;

    // Negative overflow occurs if A is negative (1), B is positive (0), but result is positive (0)
    wire neg_overflow = sign_A & (~sign_B) & (~sign_res);

    // Overflow flag asserted if either overflow condition occurs
    assign overflow = pos_overflow | neg_overflow;

endmodule