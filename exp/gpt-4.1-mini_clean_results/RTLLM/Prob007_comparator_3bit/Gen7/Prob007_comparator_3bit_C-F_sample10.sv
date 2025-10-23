module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    wire any_bit_diff;
    wire gt_bit2;
    wire gt_bit1;
    wire gt_bit0;

    // Equality: all bits equal means XOR reduction is zero
    assign any_bit_diff = |(A ^ B);
    assign A_equal = ~any_bit_diff;

    // Greater: hierarchical bitwise comparison from MSB to LSB
    assign gt_bit2 =  A[2] & ~B[2];
    assign gt_bit1 = (~(A[2] ^ B[2])) & (A[1] & ~B[1]);
    assign gt_bit0 = (~(A[2] ^ B[2])) & (~(A[1] ^ B[1])) & (A[0] & ~B[0]);

    assign A_greater = gt_bit2 | gt_bit1 | gt_bit0;

    // Less is true when not equal and not greater
    assign A_less = ~A_equal & ~A_greater;

endmodule