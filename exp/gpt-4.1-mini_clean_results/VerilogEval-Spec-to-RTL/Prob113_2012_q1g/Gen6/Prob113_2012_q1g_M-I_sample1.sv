module TopModule(
    input  [3:0] x,
    output       f
);

    wire not_x0 = ~x[0];
    wire not_x1 = ~x[1];
    wire not_x2 = ~x[2];
    wire not_x3 = ~x[3];

    // Term 1: row 00, columns 00 and 10 -> x2=0, x3=0, x1=0
    wire term1 = not_x2 & not_x3 & not_x1;

    // Term 2: row 10, columns 00,01,10 -> x2=1, x3=0, x1=0
    wire term2 = x[2] & not_x3 & not_x1;

    // Term 3: row 11, columns 00,01,11 -> x2=1, x3=1, columns x0x1 in {00,01,11}
    // which is: (not_x0 & not_x1) | (not_x0 & x[1]) | (x[0] & x[1]) = (~x0) + (x1)
    wire term3 = x[2] & x[3] & (not_x0 | x[1]);

    assign f = term1 | term2 | term3;

endmodule