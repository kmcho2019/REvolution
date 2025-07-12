module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality using XNOR and reduction AND
    wire [3:0] bit_equal;
    assign bit_equal[3:0] = ~(A[3:0] ^ B[3:0]);
    wire equal = &bit_equal[3:0];

    // Bitwise greater-than for each position
    wire [3:0] bit_greater;
    assign bit_greater[3] = A[3] & ~B[3];
    assign bit_greater[2] = A[2] & ~B[2] & bit_equal[3];
    assign bit_greater[1] = A[1] & ~B[1] & &bit_equal[3:2];
    assign bit_greater[0] = A[0] & ~B[0] & &bit_equal[3:1];

    // Combined greater-than signal
    wire greater = |bit_greater[3:0];

    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule