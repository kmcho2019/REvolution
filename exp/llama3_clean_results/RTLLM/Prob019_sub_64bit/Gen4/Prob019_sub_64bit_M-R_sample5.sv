module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    wire [63:0] diff;
    wire sign_A, sign_B, sign_result;
    wire pos_overflow, neg_overflow;

    assign diff = A - B;
    assign sign_A = A[63];
    assign sign_B = B[63];
    assign sign_result = diff[63];

    assign pos_overflow = ~sign_A & sign_B & sign_result; // Positive overflow condition
    assign neg_overflow = sign_A & ~sign_B & ~sign_result; // Negative overflow condition

    assign overflow = pos_overflow | neg_overflow; // Set overflow if either condition is true
    assign result = diff;

endmodule