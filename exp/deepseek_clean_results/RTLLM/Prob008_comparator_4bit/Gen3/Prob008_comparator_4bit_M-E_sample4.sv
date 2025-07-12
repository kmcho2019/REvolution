module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Intermediate comparison results for each bit position
    wire [3:0] bit_greater;
    wire [3:0] bit_less;
    wire [3:0] bit_equal;

    // Generate comparison for each bit
    assign bit_greater[3] = A[3] & ~B[3];
    assign bit_less[3] = ~A[3] & B[3];
    assign bit_equal[3] = ~(bit_greater[3] | bit_less[3]);

    assign bit_greater[2] = bit_equal[3] & A[2] & ~B[2];
    assign bit_less[2] = bit_equal[3] & ~A[2] & B[2];
    assign bit_equal[2] = bit_equal[3] & ~(A[2] ^ B[2]);

    assign bit_greater[1] = bit_equal[2] & A[1] & ~B[1];
    assign bit_less[1] = bit_equal[2] & ~A[1] & B[1];
    assign bit_equal[1] = bit_equal[2] & ~(A[1] ^ B[1]);

    assign bit_greater[0] = bit_equal[1] & A[0] & ~B[0];
    assign bit_less[0] = bit_equal[1] & ~A[0] & B[0];
    assign bit_equal[0] = bit_equal[1] & ~(A[0] ^ B[0]);

    // Final outputs
    assign A_greater = bit_greater[3] | bit_greater[2] | 
                      bit_greater[1] | bit_greater[0];
    assign A_less = bit_less[3] | bit_less[2] | 
                   bit_less[1] | bit_less[0];
    assign A_equal = bit_equal[0];

endmodule