module TopModule(
    input  [3:0] x,
    output      f
);
    // According to the problem:
    // Row index = x[2] x[3]
    // Column index = x[0] x[1]
    // So define variables accordingly:
    wire r1 = x[2]; // row MSB
    wire r0 = x[3]; // row LSB
    wire c1 = x[0]; // col MSB
    wire c0 = x[1]; // col LSB

    // Karnaugh map (rows = r1 r0, cols = c1 c0):
    //
    //           c1 c0
    //        00   01   11   10
    // r1 r0 +----+----+----+----+
    //  00   | 1  | 0  | 0  | 1  |
    //  01   | 0  | 0  | 0  | 0  |
    //  11   | 1  | 1  | 1  | 0  |
    //  10   | 1  | 1  | 0  | 1  |

    // For clarity, minterms with f=1:
    // (r1 r0 c1 c0)
    // 0 0 0 0 = 0x0
    // 0 0 1 0 = 0x2
    // 1 1 0 0 = 3x0
    // 1 1 0 1 = 3x1
    // 1 1 1 1 = 3x3
    // 1 0 0 0 = 2x0
    // 1 0 0 1 = 2x1
    // 1 0 1 0 = 2x2
    // 0 0 0 0 and 0 0 1 0 corresponds to (r1,r0,c1,c0) minterms 0 and 2
    // Similarly for other ones.

    // Let's find groups:

    // Group 1: Column c1 c0 = 0 0 (col 00)
    // Rows with 1: 00, 10, 11
    // That is: r1 r0 = 00,10,11 (rows)
    // So group includes: r0=0 for rows 00 and 10, plus 11 (r1=1,r0=1)
    // But row 01 is 0 in this column, so not included.
    // This suggests term: c1'=1, c0'=1 (col = 00), and r0'=1 (since row 01=0)
    // But row 11 included means r0 can be 1; since row 01 is 0, no simplification on r0.
    // So minimal for this group is c1' c0'.

    // Group 2: Rows r1 r0 = 10 and 11, columns 01 and 00
    // This group covers 1s at (10,00), (10,01), (11,00), (11,01)
    // For rows: r1=1, r0=0 or 1
    // For columns: c1=0, c0=1 or 0
    // So this is r1=1, c1=0 (ignore r0 and c0)
    // term: r1 & ~c1

    // Group 3: Row 00, Columns 10 (c1=1, c0=0)
    // (00,10) = 1
    // And row 10, column 10 = 1 as well (10,10)
    // So rows r1 r0 = 00,10 with columns c1 c0 = 1 0
    // This gives: c1=1, c0=0, and r0=0 (because 00 and 10 differ in r1)
    // So minimal term: c1 & ~c0 & ~r0

    // Group 4: Row 11, Columns 11 (c1=1, c0=1)
    // (11,11) = 1
    // No group to extend here, so term: r1 & r0 & c1 & c0

    // Summarizing terms:

    // Term1: ~c1 & ~c0
    // Term2: r1 & ~c1
    // Term3: c1 & ~c0 & ~r0
    // Term4: r1 & r0 & c1 & c0

    // Verilog implementation:

    wire term1 = ~c1 & ~c0;
    wire term2 = r1 & ~c1;
    wire term3 = c1 & ~c0 & ~r0;
    wire term4 = r1 & r0 & c1 & c0;

    assign f = term1 | term2 | term3 | term4;

endmodule