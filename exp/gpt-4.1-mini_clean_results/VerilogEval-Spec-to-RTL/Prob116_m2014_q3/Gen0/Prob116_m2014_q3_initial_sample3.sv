module TopModule (
    input  [3:0] x,
    output      f
);
    // Rename inputs for clarity (1-based indexing from the problem, zero-based here)
    // x[3]x[2] for rows (MSBs), x[1]x[0] for columns (LSBs)
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Karnaugh map (x3x2 rows, x1x0 cols):
    //           00    01    11    10
    // 00 (0,0)  d     0     d     d
    // 01 (0,1)  0     d     1     0
    // 11 (1,1)  1     1     d     d
    // 10 (1,0)  1     1     0     d

    // We convert this to minterms (for f=1):
    // Minterms with 1: (row col)
    // (01,11) = x3x2=01, x1x0=11 -> x3=0,x2=1,x1=1,x0=1 => 0b0111 = 7
    // (11,00) = x3x2=11, x1x0=00 -> 0b1100 = 12
    // (11,01) = x3x2=11, x1x0=01 -> 0b1101 = 13
    // (10,00) = 10 00 = 0b1000 = 8
    // (10,01) = 10 01 = 0b1001 = 9
    // Also, cells with 0 at (01,00), (01,10), (00,01) etc. are zeros.

    // From the K-map and the don't cares, we can cover the 1s with groups:
    // Group 1: Row 11 col 00 and 01: x3=1,x2=1, x1=0 or 1, x0=0 or 1
    // => x3 & x2
    //
    // Group 2: Row 10 col 00 and 01: x3=1,x2=0, x1=0 or 1, x0=0 or 1 but (10,11)=0
    // Actually (10,11)=0 so can't group all four, but (10,00) and (10,01)=1
    // So group for these two cells: x3=1,x2=0,x0=0 (because col 00 and 01 means x0=0/1)
    // Actually col 00=00 and 01=01: x1=0 in both (col 00: x1=0,x0=0; col 01: x1=0,x0=1)
    // So x3=1,x2=0,x1=0, x0=don't care => x3 & ~x2 & ~x1
    //
    // Group 3: Single cell (01,11): x3=0,x2=1,x1=1,x0=1
    // Just a minterm: ~x3 & x2 & x1 & x0

    // Group 4: Row 11 col 00 and 01 covered by Group 1
    // Check if other grouping possible

    // Group 5: Row 11 col 00 and 01 together: x3 & x2

    // Also group (11,01) and (10,01) = both 1
    // (11,01)=13, (10,01)=9 -> x2=1 or 0, x3=1 both, x1=0, x0=1
    // So x3 & x0 & ~x1

    // This implies that (10,01) and (11,01) covered by x3 & x0 & ~x1,
    // (10,00) and (11,00) covered by x3 & x2 & ~x0, but (10,00)=8, (11,00)=12

    // Let's try simpler approach:
    // Let's write SOP from 1s and combine if possible

    // Minterms:
    // 7:  0 1 1 1 => ~x3 & x2 & x1 & x0
    // 8:  1 0 0 0 => x3 & ~x2 & ~x1 & ~x0
    // 9:  1 0 0 1 => x3 & ~x2 & ~x1 & x0
    // 12: 1 1 0 0 => x3 & x2 & ~x1 & ~x0
    // 13: 1 1 0 1 => x3 & x2 & ~x1 & x0

    // Combine minterms 8 and 9:
    // x3 & ~x2 & ~x1 & ( ~x0 + x0 ) = x3 & ~x2 & ~x1
    // Combine minterms 12 and 13:
    // x3 & x2 & ~x1 & ( ~x0 + x0 ) = x3 & x2 & ~x1

    // So f = (~x3 & x2 & x1 & x0) + (x3 & ~x2 & ~x1) + (x3 & x2 & ~x1)

    // Simplify last two terms:
    // x3 & ~x1 & (~x2 + x2) = x3 & ~x1

    // Final expression:
    // f = (~x3 & x2 & x1 & x0) + (x3 & ~x1)

    assign f = (~x3 & x2 & x1 & x0) | (x3 & ~x1);

endmodule