module TopModule (
    input  [3:0] x,
    output      f
);

    wire x3 = x[3];
    wire x4 = x[2];
    wire x1 = x[1];
    wire x2 = x[0];

    // Re-mapping input bits to match the Karnaugh map axes as described:
    // According to problem: x[1]x[2] are column bits, so x[1] = x[1], x[2] = x[0]
    // x[3]x[4] are row bits, so x[3] = x[3], x[4] = x[2]
    // So the variable assignment in code is:
    // row = x3 x4 = x[3] x[2]
    // col = x1 x2 = x[1] x[0]
    // The K-map can be interpreted as follows (rows, columns in Gray code order):
    // Rows (x3 x4): 00,01,11,10
    // Columns (x1 x2): 00,01,11,10

    // Using the K-map:
    // For rows 00 (x3=0,x4=0): col=00->d, 01->0, 11->d, 10->d
    // For rows 01 (x3=0,x4=1): col=00->0, 01->d, 11->1, 10->0
    // For rows 11 (x3=1,x4=1): col=00->1, 01->1, 11->d, 10->d
    // For rows 10 (x3=1,x4=0): col=00->1, 01->1, 11->0, 10->d

    // Let's write minterms for '1's:
    // row=11 col=00 -> x3=1,x4=1,x1=0,x2=0 -> x3 x4 ~x1 ~x2
    // row=11 col=01 -> x3=1,x4=1,x1=0,x2=1 -> x3 x4 ~x1 x2
    // row=10 col=00 -> x3=1,x4=0,x1=0,x2=0 -> x3 ~x4 ~x1 ~x2
    // row=10 col=01 -> x3=1,x4=0,x1=0,x2=1 -> x3 ~x4 ~x1 x2
    // row=01 col=11 -> x3=0,x4=1,x1=1,x2=1 -> ~x3 x4 x1 x2

    // We can group these minterms to simplify:
    // Group 1: (x3=1, x1=0, x2=don't care), row 11 or 10 (x4=0 or 1)
    //   Covers x3=1, x1=0 => x3 & ~x1
    // Group 2: (x3=1, x4=1, x1=0) covers 2 minterms with x2=0 or 1 (already in group 1)
    // Group 3: (row=01, col=11) minterm alone: ~x3 & x4 & x1 & x2

    // Check if Group 1 covers all 4 minterms for x3=1 and x1=0:
    // row=11 col=00 (x3=1,x4=1,x1=0,x2=0) -> yes
    // row=11 col=01 (x3=1,x4=1,x1=0,x2=1) -> yes
    // row=10 col=00 (x3=1,x4=0,x1=0,x2=0) -> yes
    // row=10 col=01 (x3=1,x4=0,x1=0,x2=1) -> yes

    // So Group 1 is x3 & ~x1

    // The other 1 is at ~x3 & x4 & x1 & x2

    // So f = (x3 & ~x1) + (~x3 & x4 & x1 & x2)

    assign f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

endmodule