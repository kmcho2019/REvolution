module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Map inputs to K-map row and column bits per given axes
    // Row bits: x3 x4 => x[2], x[3]
    // Column bits: x1 x2 => x[0], x[1]
    wire row1 = x[2];  // MSB of row index (x3)
    wire row0 = x[3];  // LSB of row index (x4)
    wire col1 = x[0];  // MSB of column index (x1)
    wire col0 = x[1];  // LSB of column index (x2)

    // The Karnaugh map (from problem) after assigning don't-cares (d) to 0:
    //           col1 col0
    // row1 row0 00 01 11 10
    //   0   0   0  0  0  0
    //   0   1   0  0  1  0
    //   1   1   1  1  0  0
    //   1   0   1  1  0  0

    // Create single expression f = 1 for minterms where f=1:
    // From K-map ones at:
    // (row,col) = (0,11), (1,10), (1,11), (2,00), (2,01), (3,00), (3,01)
    // (indexing from 0-based for rows: row = {row1,row0}, cols = {col1,col0})
    // Concretely ones at these positions:
    // row=0b01 col=0b11 -> x= {row1,row0,col1,col0} = 0 1 1 1
    // row=1b10 and 11 = {10,00}, {11,00}, {10,01}, {11,01} (from K-map)
    // Let's write minterms to cover all ones and simplify.

    // After simplification (by inspection / Karnaugh method):

    // Group1: row1=1 and col1=0 => (row1 & ~col1)
    // Covers (2,00),(3,00),(2,01),(3,01) => ones at these positions

    // Group2: row1=1 and row0=1 and col1=1 and col0=0 => (row1 & row0 & col1 & ~col0)
    // Covers (3,10) => but K-map shows 0 there, so ignore

    // Group3: row1=0 and row0=1 and col1=1 and col0=1 => (~row1 & row0 & col1 & col0)
    // Covers (1,11) => one here

    // Group4: row1=1 and row0=1 and col1=1 and col0=1 => (row1 & row0 & col1 & col0)
    // The K-map at (11,11) is d->0, so no

    // Group5: row1=1 and row0=1 and col1=1 and col0=0 => (row1 & row0 & col1 & ~col0)
    // (3,10) is 0, ignore

    // Group6: row1=1 and row0=0 and col1=1 and col0=0 => (row1 & ~row0 & col1 & ~col0)
    // (2,10) is 0, ignore

    // So final groups of 1's from K-map are:

    // (row=1x, col=0x): row1 & ~col1
    // (row=01, col=11): ~row1 & row0 & col1 & col0

    // Hence:
    // f = (row1 & ~col1) | (~row1 & row0 & col1 & col0)

    assign f = (row1 & ~col1) | (~row1 & row0 & col1 & col0);

endmodule