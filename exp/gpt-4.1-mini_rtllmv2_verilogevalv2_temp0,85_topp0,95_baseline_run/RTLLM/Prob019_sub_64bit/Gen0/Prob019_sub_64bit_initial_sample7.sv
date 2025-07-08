module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    assign result = A - B;

    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_R = result[63];

    // Overflow detection for subtraction:
    // overflow if (sign_A == 0 and sign_B == 1 and sign_R == 1) OR
    //             (sign_A == 1 and sign_B == 0 and sign_R == 0)
    assign overflow = (~sign_A & sign_B & sign_R) | (sign_A & ~sign_B & ~sign_R);

endmodule