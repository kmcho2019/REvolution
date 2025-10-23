module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare bits from MSB to LSB:
    // For each bit i:
    // greater_i = (A[i] & ~B[i]) | (equal_i & greater_{i-1})
    // less_i = (~A[i] & B[i]) | (equal_i & less_{i-1})
    // equal_i = ~(A[i] ^ B[i])
    // but since we go from MSB downward, we directly define greater and less hierarchically.

    wire bit_eq [3:0];
    wire bit_gt [3:0];
    wire bit_lt [3:0];

    // Bitwise equality
    assign bit_eq[3] = ~(A[3] ^ B[3]);
    assign bit_eq[2] = ~(A[2] ^ B[2]);
    assign bit_eq[1] = ~(A[1] ^ B[1]);
    assign bit_eq[0] = ~(A[0] ^ B[0]);

    // For MSB (bit 3)
    assign bit_gt[3] = (A[3] & ~B[3]);
    assign bit_lt[3] = (~A[3] & B[3]);

    // For bit 2
    assign bit_gt[2] = (A[2] & ~B[2]) & bit_eq[3];
    assign bit_lt[2] = (~A[2] & B[2]) & bit_eq[3];

    // For bit 1
    assign bit_gt[1] = (A[1] & ~B[1]) & bit_eq[3] & bit_eq[2];
    assign bit_lt[1] = (~A[1] & B[1]) & bit_eq[3] & bit_eq[2];

    // For bit 0
    assign bit_gt[0] = (A[0] & ~B[0]) & bit_eq[3] & bit_eq[2] & bit_eq[1];
    assign bit_lt[0] = (~A[0] & B[0]) & bit_eq[3] & bit_eq[2] & bit_eq[1];

    // Aggregate greater and less by ORing all bit positions
    assign A_greater = |bit_gt;
    assign A_less    = |bit_lt;

    // Equality: all bits equal
    assign A_equal = &bit_eq;

endmodule