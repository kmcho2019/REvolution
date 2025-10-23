module TopModule(
    input  [3:0] x,
    output f
);
    // According to the problem:
    // Rows = x[2]x[3]
    // Columns = x[0]x[1]
    // But the input vector is x = {x[3], x[2], x[1], x[0]}
    // To get row index from x[2]x[3], note x[3] is bit3, x[2] is bit2
    wire [1:0] row = {x[2], x[3]};  // MSB x[2], LSB x[3]
    wire [1:0] col = {x[0], x[1]};  // MSB x[0], LSB x[1]

    // Karnaugh map entries (row, col):
    // row\col 00 01 11 10
    // 00      1  0  0  1
    // 01      0  0  0  0
    // 11      1  1  1  0
    // 10      1  1  0  1

    // To build f, write minterms where f=1 for given row and col:
    // For each cell with 1, write expression that matches row and col bits:
    // row = {x[2], x[3]}, col = {x[0], x[1]}

    // Let's write sum of minterms as f = sum of terms where f=1.

    assign f = 
        // Row 00 (x[2]=0, x[3]=0)
        (~x[2] & ~x[3] & ~x[0] & ~x[1]) |  // col 00 = 1
        (~x[2] & ~x[3] &  x[0] & ~x[1]) |  // col 10 = 1

        // Row 11 (x[2]=1, x[3]=1)
        ( x[2] &  x[3] & ~x[0] & ~x[1]) |  // col 00 = 1
        ( x[2] &  x[3] & ~x[0] &  x[1]) |  // col 01 = 1
        ( x[2] &  x[3] &  x[0] &  x[1]) |  // col 11 = 1

        // Row 10 (x[2]=1, x[3]=0)
        ( x[2] & ~x[3] & ~x[0] & ~x[1]) |  // col 00 = 1
        ( x[2] & ~x[3] & ~x[0] &  x[1]) |  // col 01 = 1
        ( x[2] & ~x[3] &  x[0] & ~x[1])    // col 10 = 1
        ;

endmodule