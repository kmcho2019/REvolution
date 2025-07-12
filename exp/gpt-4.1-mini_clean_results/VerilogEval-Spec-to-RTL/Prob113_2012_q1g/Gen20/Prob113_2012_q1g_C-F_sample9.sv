module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared inverted signals
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // First large term: ~x3 & ( ~x1 | (x2 & ~x0) )
    wire termA = nx1 | (x2 & nx0);
    wire part1 = nx3 & termA;

    // Second large term: x3 & x2 & ( ~x0 | x1 )
    wire termB = nx0 | x1;
    wire part2 = x3 & x2 & termB;

    assign f = part1 | part2;

endmodule