module sub_64bit(
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
    wire sign_res = result[63];

    // Overflow detection:
    // Overflow occurs if signs of A and B differ, and sign of result differs from sign of A
    assign overflow = (sign_A != sign_B) && (sign_res != sign_A);

endmodule