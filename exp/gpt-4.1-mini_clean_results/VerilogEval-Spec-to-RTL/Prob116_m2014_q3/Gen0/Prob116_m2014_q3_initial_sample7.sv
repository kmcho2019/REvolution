module TopModule(
    input [3:0] x,
    output f
);
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // From Karnaugh Map:
    // Rows: x3 x2
    // Cols: x1 x0
    //
    // Map entries (rows x3x2, columns x1x0):
    //       00   01    11    10
    // 00:   d     0     d     d
    // 01:   0     d     1     0
    // 11:   1     1     d     d
    // 10:   1     1     0     d
    //
    // Treating d as don't-care, choose values to minimize logic.
    //
    // We can write minterms for '1's:
    // minterms = (01,11) in row 11 (x3x2=11): columns 00 and 01: (11 00)= x3x2x1x0 = 1100, (11 01)=1101
    // (11 00) = x3=1 x2=1 x1=0 x0=0
    // (11 01) = x3=1 x2=1 x1=0 x0=1
    //
    // Row 10: 10 00=1 and 10 01=1 and 10 11=0, 10 10=d
    // (10 00)= x3=1 x2=0 x1=0 x0=0 (1)
    // (10 01)= x3=1 x2=0 x1=0 x0=1 (1)
    //
    // Row 01: 01 11=1
    // (01 11)= x3=0 x2=1 x1=1 x0=1
    //
    // Now find groups for simplification:
    //
    // Group 1: row 11, col 00 and 01: x3x2=11, x1=0, x0= don't care (since both 0 and 1)
    // Group 2: row 10, col 00 and 01: x3=1, x2=0, x1=0, x0= don't care (0 or 1)
    // Group 3: row 11 and 10, col 01: both 1 (11 01 and 10 01)
    // Group 4: single minterm (01 11)
    //
    // Let's derive simplified expression:
    // Group 1: x3 & x2 & ~x1
    // Group 2: x3 & ~x2 & ~x1
    // Group 3: x3 & x0 & ~x2  (actually both 11 01 and 10 01 have x3=1, x0=1, x2=1 or 0, x1=0)
    // But 10 01 = x3=1, x2=0, x1=0, x0=1 is covered by Group 2 and 3 overlap?
    // Actually, Group 2 covers (10 00, 10 01) => x3=1, x2=0, x1=0 (x0 don't care)
    // Group 3 overlaps partially with Group 2.
    //
    // The combined expression for rows 11 and 10 and columns 00 and 01 can be:
    // x3 & ~x1
    //
    // Row 01 11 (0 1 1 1) = minterm: ~x3 & x2 & x1 & x0
    //
    // Now, check remaining 1's:
    // Row 11 00 (1100) and 11 01 (1101) covered by x3 & x2 & ~x1
    //
    // So final expression:
    // f = (x3 & ~x1) | (~x3 & x2 & x1 & x0)
    //
    // This covers all 1's and the 0's in the map are not included.
    //
    // Note: For don't-care inputs, we don't care what output is.
    
    assign f = (x3 & ~x1) | (~x3 & x2 & x1 & x0);

endmodule