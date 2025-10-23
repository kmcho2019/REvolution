module TopModule(
    input  [3:0] x,
    output f
);
    // Extract bits for clarity
    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // Karnaugh map rows: x2 x3
    // columns: x0 x1

    // After analysis, minimal expression derived is:
    // f = (~x2 & ~x3 & (~x0 & ~x1 | x0 & ~x1)) | 
    //     (x2 & x3 & (~x1)) |
    //     (x2 & ~x3 & (~x1 | ~x0))

    wire row00 = ~x2 & ~x3;
    wire row01 = ~x2 & x3;
    wire row11 = x2 & x3;
    wire row10 = x2 & ~x3;

    // Columns combinations for row00: f=1 at col 00 and 10 => (~x0&~x1) + (x0&~x1) = ~x1
    wire col00 = ~x0 & ~x1;
    wire col01 = ~x0 & x1;
    wire col11 = x0 & x1;
    wire col10 = x0 & ~x1;

    // Simplify row00: f=1 when col00 or col10 is true -> ( (~x0 & ~x1) | (x0 & ~x1) ) = ~x1

    // row11: f=1 at cols 00,01,11 (all except 10)
    // So row11 and ~col10 = row11 & ~ (x0 & ~x1) = row11 & (~x0 | x1)
    // but better to write as row11 & (~x1)

    // row10: f=1 at cols 00,01,10 -> col11=0
    // So row10 & ~col11 = row10 & ~(x0 & x1) = row10 & (~x0 | ~x1)
    
    assign f = (row00 & ~x1) |
               (row11 & ~x1) |
               (row10 & (~x0 | ~x1));

endmodule