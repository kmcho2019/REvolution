module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits for clarity
    wire sign_A   = A[63];
    wire sign_B   = B[63];
    wire sign_res = result[63];

    // Overflow detection: occurs if sign of A and B differ,
    // and result sign differs from A's sign (two's complement overflow)
    assign overflow = (sign_A != sign_B) && (sign_res != sign_A);

endmodule