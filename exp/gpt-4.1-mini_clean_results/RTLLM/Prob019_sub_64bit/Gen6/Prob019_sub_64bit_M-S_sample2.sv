module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Perform subtraction
    assign result = A - B;

    // Overflow detection:
    // Overflow occurs if A and B have different signs and result sign differs from A sign
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule