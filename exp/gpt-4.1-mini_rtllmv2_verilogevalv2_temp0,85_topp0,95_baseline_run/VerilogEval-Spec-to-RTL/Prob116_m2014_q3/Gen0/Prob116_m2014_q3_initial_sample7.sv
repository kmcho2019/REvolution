module TopModule (
    input  [3:0] x,
    output      f
);
    // Map variables for clarity:
    // x[3:2] = row, x[1:0] = column

    // Given Karnaugh Map:
    //       00  01  11  10   (x[1]x[0])
    // 00 | d | 0 | d | d |   (x[3]x[2] = 00)
    // 01 | 0 | d | 1 | 0 |   (x[3]x[2] = 01)
    // 11 | 1 | 1 | d | d |   (x[3]x[2] = 11)
    // 10 | 1 | 1 | 0 | d |   (x[3]x[2] = 10)

    // Let's rewrite the known values and don't-cares as minterms (m) and dcs:
    // Assign variables for clarity:
    // A = x[3], B = x[2], C = x[1], D = x[0]

    // Minterms where f=1:
    // Row 01 Col 11 -> A=0,B=1,C=1,D=1 -> m7 (0111)
    // Row 11 Col 00 -> 1 1 0 0 -> m12 (1100)
    // Row 11 Col 01 -> 1 1 0 1 -> m13 (1101)
    // Row 10 Col 00 -> 1 0 0 0 -> m8  (1000)
    // Row 10 Col 01 -> 1 0 0 1 -> m9  (1001)

    // Minterms where f=0:
    // Row 00 Col 01 -> 0 0 0 1 -> m1
    // Row 01 Col 00 -> 0 1 0 0 -> m4
    // Row 01 Col 10 -> 0 1 1 0 -> m6

    // Don't cares are the rest.

    // From the Karnaugh map, group the 1s and use don't-cares for simplification.

    // Groups can be:

    // Group 1: m12(1100), m13(1101), m8(1000), m9(1001)
    // These share pattern A=1, C=0, D=don't-care, B=don't-care but carefully:
    // Actually, m8(1000) and m9(1001) share A=1,B=0,C=0
    // m12(1100) and m13(1101) share A=1,B=1,C=0

    // So no direct big group including all four, but can group two pairs:
    // Group 1a: m8,m9 => A=1,B=0,C=0
    // Group 1b: m12,m13 => A=1,B=1,C=0

    // Group 2: m7(0111) alone.

    // Also m13 and m9 share C=0, D=1 and A=1 but B differs.

    // We can use don't-cares to group m7(0111) with don't-cares.

    // Alternatively, implement the minterms directly and use the don't-cares to simplify.

    // Simplified SOP:
    // f = A & ~C & ~B (covers m8,m9) + A & ~C & B (covers m12,m13) + ~A & B & C & D (m7)

    // So,
    // f = A & ~C + ~A & B & C & D

    // Because A & ~C covers m8,m9,m12,m13 (since m12,m13 have B=1, but since it's not in the term, it covers both B=0 and B=1 cases)

    // Wait, check if A & ~C covers m12,m13:

    // For m12: A=1,C=0 => yes

    // For m13: A=1,C=0 => yes

    // For m8: A=1,C=0 => yes

    // For m9: A=1,C=0 => yes

    // So f = A & ~C + ~A & B & C & D

    // Check for zeros to avoid errors:

    // f=0 at m1(0001): A=0,C=0 so first term 0, second term requires ~A & B & C & D = 0 & 0 & 0 & 1 =0 => f=0 ok

    // At m4(0100): A=0,B=1,C=0,D=0; first term = 0; second term = 0 & 1 & 0 & 0=0 -> f=0 ok

    // At m6(0110): A=0,B=1,C=1,D=0; first term=0; second term=0 & 1 & 1 & 0=0 f=0 ok

    // So logic holds.

    wire A = x[3];
    wire B = x[2];
    wire C = x[1];
    wire D = x[0];

    assign f = (A & ~C) | (~A & B & C & D);

endmodule