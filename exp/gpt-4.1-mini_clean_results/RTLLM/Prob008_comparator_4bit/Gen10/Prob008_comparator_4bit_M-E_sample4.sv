module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per bit comparisons: greater, equal, less
    wire [3:0] gt, eq, lt;

    assign gt = A & ~B;     // bit is 1 for A[i] > B[i]
    assign lt = ~A & B;     // bit is 1 for A[i] < B[i]
    assign eq = ~(A ^ B);   // bit is 1 for A[i] == B[i]

    // Cascade signals for each bit to determine final comparison
    // Starting from MSB (bit 3) to LSB (bit 0)

    // From MSB down to LSB, determine if A > B or A < B or equal so far
    wire bit3_greater = gt[3];
    wire bit3_less    = lt[3];
    wire bit3_equal   = eq[3];

    wire bit2_greater = gt[2] & bit3_equal;
    wire bit2_less    = lt[2] & bit3_equal;
    wire bit2_equal   = eq[2] & bit3_equal;

    wire bit1_greater = gt[1] & bit3_equal & bit2_equal;
    wire bit1_less    = lt[1] & bit3_equal & bit2_equal;
    wire bit1_equal   = eq[1] & bit3_equal & bit2_equal;

    wire bit0_greater = gt[0] & bit3_equal & bit2_equal & bit1_equal;
    wire bit0_less    = lt[0] & bit3_equal & bit2_equal & bit1_equal;
    wire bit0_equal   = eq[0] & bit3_equal & bit2_equal & bit1_equal;

    // A_equal is when all bits equal
    assign A_equal = bit3_equal & bit2_equal & bit1_equal & bit0_equal;

    // A_greater if any bit comparison shows greater before less
    assign A_greater = bit3_greater | bit2_greater | bit1_greater | bit0_greater;

    // A_less if any bit comparison shows less before greater
    assign A_less = bit3_less | bit2_less | bit1_less | bit0_less;

endmodule