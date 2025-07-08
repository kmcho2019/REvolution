module TopModule(
    input [3:0] x,
    output f
);
    // According to the Karnaugh map:
    // Rows: x[3]x[2]
    // Columns: x[1]x[0]
    // Map:
    //       00 01 11 10 (x[1]x[0])
    // 00 | d | 0 | d | d |  (x[3]x[2] = 00)
    // 01 | 0 | d | 1 | 0 |  (x[3]x[2] = 01)
    // 11 | 1 | 1 | d | d |  (x[3]x[2] = 11)
    // 10 | 1 | 1 | 0 | d |  (x[3]x[2] = 10)

    // Minimize the function f:
    // Let's define variables for clarity:
    // r = x[3]x[2], c = x[1]x[0]

    // Mark 1's positions (r,c):
    // (01,11), (11,00), (11,01), (10,00), (10,01), (01,11), (11,00), (11,01)
    // (01,11) -> x= (0 1 1 1) = 7
    // (11,00) -> x= (1 1 0 0) = 12
    // (11,01) -> x= (1 1 0 1) = 13
    // (10,00) -> x= (1 0 0 0) = 8
    // (10,01) -> x= (1 0 0 1) = 9

    // Ones at: 7,8,9,12,13

    // Don't cares can be used to simplify.

    // From map and analysis, one minimized expression for f is:
    // f = (x[3] & ~x[2])       // row 10, columns 00 and 01 with 1's
    //   | (x[3] & x[2] & ~x[1]) // row 11, column 00 and 01
    //   | (~x[3] & x[2] & x[1] & x[0]) // the 1 at row 01 col 11 (7)

    assign f = (x[3] & ~x[2]) 
             | (x[3] & x[2] & ~x[1]) 
             | (~x[3] & x[2] & x[1] & x[0]);

endmodule