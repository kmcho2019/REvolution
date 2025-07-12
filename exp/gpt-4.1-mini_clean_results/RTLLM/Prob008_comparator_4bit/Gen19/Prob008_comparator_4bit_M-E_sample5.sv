module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bit-level comparators: for each bit i,
    //   bit_greater[i] = (A[i] == 1) & (B[i] == 0)
    //   bit_less[i]    = (A[i] == 0) & (B[i] == 1)
    //   bit_equal[i]   = (A[i] == B[i])

    wire [3:0] bit_greater = A & ~B;
    wire [3:0] bit_less    = ~A & B;
    wire [3:0] bit_equal   = ~(A ^ B);

    // Now cascade from MSB to LSB:
    // For bit 3 (MSB):
    //   if bit_greater[3] == 1 -> A_greater = 1
    //   else if bit_less[3] == 1 -> A_less = 1
    //   else (bit_equal[3] == 1) check next bit
    // Repeat down to bit 0
    // If all bits equal, then A_equal = 1

    // Signals tracking comparison after each bit starting from MSB
    // Using generate block not needed since fixed width

    // First compare MSB bit (bit 3)
    wire gt3 = bit_greater[3];
    wire lt3 = bit_less[3];
    wire eq3 = bit_equal[3];

    // Compare bit 2 only if bit 3 equal
    wire gt2 = eq3 & bit_greater[2];
    wire lt2 = eq3 & bit_less[2];
    wire eq2 = eq3 & bit_equal[2];

    // Compare bit 1 only if bits 3,2 equal
    wire gt1 = eq2 & bit_greater[1];
    wire lt1 = eq2 & bit_less[1];
    wire eq1 = eq2 & bit_equal[1];

    // Compare bit 0 only if bits 3,2,1 equal
    wire gt0 = eq1 & bit_greater[0];
    wire lt0 = eq1 & bit_less[0];
    wire eq0 = eq1 & bit_equal[0];

    // Compose final outputs by priority:
    // A_greater if any gt[i] is 1
    // A_less if any lt[i] is 1 and no gt[i] is 1
    // A_equal if all bits equal (eq0)

    wire any_gt = gt3 | gt2 | gt1 | gt0;
    wire any_lt = lt3 | lt2 | lt1 | lt0;

    assign A_greater = any_gt;
    assign A_less    = ~any_gt & any_lt;
    assign A_equal   = eq0 & ~any_gt & ~any_lt;

endmodule