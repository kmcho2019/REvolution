module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Perform direct 64-bit subtraction using Verilog operator
    assign result = A - B;

    // Overflow detection:
    // Overflow occurs if:
    // - A is positive, B is negative, and result is negative (positive overflow)
    // - A is negative, B is positive, and result is positive (negative overflow)
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule