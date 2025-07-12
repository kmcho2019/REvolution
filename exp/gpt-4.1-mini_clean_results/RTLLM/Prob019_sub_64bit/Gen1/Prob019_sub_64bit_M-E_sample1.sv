module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute two's complement of B
    wire [63:0] B_neg = ~B + 64'd1;

    // Perform addition: A + (-B)
    assign result = A + B_neg;

    // Extract sign bits
    wire sign_A = A[63];
    wire sign_B_neg = B_neg[63];
    wire sign_res = result[63];

    // Overflow detection for addition: overflow if sign_A == sign_B_neg and sign_res != sign_A
    assign overflow = (sign_A == sign_B_neg) && (sign_res != sign_A);

endmodule