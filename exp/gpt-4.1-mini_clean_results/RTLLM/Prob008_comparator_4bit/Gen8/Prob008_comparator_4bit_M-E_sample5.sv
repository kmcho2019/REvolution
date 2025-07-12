module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate signals for each bit
    wire [3:0] bit_greater; // bit-wise A[i] > B[i]
    wire [3:0] bit_equal;   // bit-wise A[i] == B[i]
    wire [3:0] bit_less;    // bit-wise A[i] < B[i]

    // Generate bit-level comparison signals
    assign bit_greater = (A & ~B);
    assign bit_less    = (~A & B);
    assign bit_equal   = ~(bit_greater | bit_less);

    // Cascade the comparison from MSB to LSB:
    // At each stage, if higher bit is unequal, that determines output;
    // else rely on next lower bit.

    // For 4-bit:
    // A_greater = bit_greater[3] |
    //             (bit_equal[3] & bit_greater[2]) |
    //             (bit_equal[3] & bit_equal[2] & bit_greater[1]) |
    //             (bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_greater[0])

    wire eq_3_2_1_0 = bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_equal[0];
    wire eq_3_2_1 = bit_equal[3] & bit_equal[2] & bit_equal[1];
    wire eq_3_2 = bit_equal[3] & bit_equal[2];
    wire eq_3 = bit_equal[3];

    assign A_greater = bit_greater[3]
                     | (eq_3 & bit_greater[2])
                     | (eq_3_2 & bit_greater[1])
                     | (eq_3_2_1 & bit_greater[0]);

    assign A_less = bit_less[3]
                  | (eq_3 & bit_less[2])
                  | (eq_3_2 & bit_less[1])
                  | (eq_3_2_1 & bit_less[0]);

    assign A_equal = eq_3_2_1_0;

endmodule