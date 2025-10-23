module TopModule(
    input  [3:0] x,
    output       f
);

    // Map input bits to row and column indices as in the Karnaugh map:
    // rows = {x[2], x[3]}, columns = {x[0], x[1]}
    // The Karnaugh map groups suggest the minimal sum-of-products:

    // From the Karnaugh map, f=1 for minterms:
    // 0 (0000), 3(0011 not), 2(0010), 8(1000),9(1001),10(1010),11(1011),
    // 12(1100),13(1101),14(1110),15(1111) partially. Actually checking minterms:
    // Using the map:
    // (x2 x3)(x0 x1) = f
    // 00 00 =>1 (0)
    // 00 01 =>0 (1)
    // 00 11 =>0 (3)
    // 00 10 =>1 (2)
    // 01 xx => all 0
    // 11 00 =>1 (12)
    // 11 01 =>1 (13)
    // 11 11 =>1 (15)
    // 11 10 =>0 (14)
    // 10 00 =>1 (8)
    // 10 01 =>1 (9)
    // 10 11 =>0 (11)
    // 10 10 =>1 (10)

    // Minimal expression found by Karnaugh map analysis:
    // f = (~x[2] & ~x[3] & (~x[1] | x[0])) |
    //     (x[3] & ~x[2]) |
    //     (x[2] & ~x[3] & ~x[1]) |
    //     (x[2] & x[3] & (x[1] | x[0]));

    wire not_x0 = ~x[0];
    wire not_x1 = ~x[1];
    wire not_x2 = ~x[2];
    wire not_x3 = ~x[3];

    wire term1 = not_x2 & not_x3 & (not_x1 | x[0]);
    wire term2 = x[3] & not_x2;
    wire term3 = x[2] & not_x3 & not_x1;
    wire term4 = x[2] & x[3] & (x[1] | x[0]);

    assign f = term1 | term2 | term3 | term4;

endmodule