module TopModule(
    input  [3:0] x,
    output       f
);

    // Input bits
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complements
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term1: (~x1) OR (x2 AND ~x0)
    wire term1 = nx1 | (x2 & nx0);

    // Term2: (~x0) OR x1
    wire term2 = nx0 | x1;

    // Combine parts
    wire part1 = nx3 & term1;       // ~x3 & ( ~x1 | (x2 & ~x0) )
    wire part2 = x3 & x2 & term2;   // x3 & x2 & ( ~x0 | x1 )

    assign f = part1 | part2;

endmodule