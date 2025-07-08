module TopModule(
    input [3:0] x,
    output f
);
    // Assign meaningful names to bits for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];
    
    // Karnaugh map variables according to the problem:
    // Rows: x[3] x[0]
    // Columns: x[1] x[2]
    //
    // Given the problem states rows by x[3]x[4] but input is x[3:0], 
    // presumably x[3] = MSB, x[0] = LSB
    // The map indicates x[3]x[4], but since x is 4 bits x[3:0], 
    // I assume x[3] and x[0] represent row, and x[1] and x[2] represent column.
    // However, the problem states the map as x[3]x[4] for rows and x[1]x[2] for columns.
    // Since x has only 4 bits (x[3:0]), and x[4] doesn't exist, 
    // presumably x[3] is MSB and x[0] is LSB, so I treat x[3]x[0] as the two row bits.
    // Alternatively, maybe the problem counts bits from 1 to 4, so x[1] is bit 1, x[2] bit 2, x[3] bit 3, x[4] bit 4.
    // So x[3] and x[4] should correspond to x[2] and x[3] in zero-based indexing.
    // Let's map as follows:
    // x[3] (problem) -> x[2]
    // x[4] (problem) -> x[3]
    // x[1] (problem) -> x[0]
    // x[2] (problem) -> x[1]
    //
    // Thus rows = x[2]x[3], columns = x[0]x[1].

    wire r1 = x[2]; // problem's x[3]
    wire r0 = x[3]; // problem's x[4]
    wire c1 = x[0]; // problem's x[1]
    wire c0 = x[1]; // problem's x[2]

    // Karnaugh map indexed by row r1r0 and column c1c0:
    // Rows/Columns:  r1r0 / c1c0
    // r1 r0
    // 0  0: d 0 d d  => c1c0=00: d, 01:0, 11:d, 10:d
    // 0  1: 0 d 1 0
    // 1  1: 1 1 d d
    // 1  0: 1 1 0 d

    // We fill in the K-map with indexes and values:
    // r1 r0 \ c1 c0 | 00 | 01 | 11 | 10
    // 0  0           d     0     d     d
    // 0  1           0     d     1     0
    // 1  1           1     1     d     d
    // 1  0           1     1     0     d

    // Let's simplify the function using the map and choosing d's to our advantage.

    // From the K-map, cells with 1:
    // (0 1, 11) = (r1=0, r0=1, c1=1, c0=1)
    // (1 1, 00) = (r1=1, r0=1, c1=0, c0=0)
    // (1 1, 01) = (1,1,0,1)
    // (1 0, 00) = (1,0,0,0)
    // (1 0, 01) = (1,0,0,1)

    // Let's write the minterms (1s):
    // m1: r1=0,r0=1,c1=1,c0=1 => r1'=1, r0=1, c1=1, c0=1 => ~r1 & r0 & c1 & c0
    // m2: r1=1,r0=1,c1=0,c0=0 => r1=1, r0=1, c1'=1, c0'=1
    // m3: r1=1,r0=1,c1=0,c0=1
    // m4: r1=1,r0=0,c1=0,c0=0
    // m5: r1=1,r0=0,c1=0,c0=1

    // Groupings:
    // Group A: m2, m3, m4, m5 (all where r1=1 and c1=0)
    // That is: r1=1 and c1=0

    // Group B: m3, m5 also have c0=1
    // Group C: m2, m4 have c0=0

    // Group D: m1 is isolated (0 1 1 1)

    // Also, from the don't-care cells, we can set them to 1 to help grouping.

    // Let's choose d's at (0 0 00), (0 0 11), (0 0 10), (0 1 01), (1 1 11), (1 1 10), (1 0 11)

    // Using don't cares to form bigger groups:

    // Group 1: All cells with r1=1 and c1=0 (m2, m3, m4, m5) -> f = r1 & ~c1
    // Group 2: Cells with r0=1 and c0=1 (m1, m3, and d at (0 0 11)) -> f = r0 & c0
    // Group 3: Cells with r1=1 and r0=0 and c0=1 is m5 (already in group1)

    // So expression: f = (r1 & ~c1) | (r0 & c0)

    assign f = (r1 & ~c1) | (r0 & c0);

endmodule