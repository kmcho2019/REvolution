module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Intermediate terms for simplified expression
    wire part1 = x3 & (x2 | x1);
    wire part2 = nx3 & nx0 & (nx1 | (x2 & x1));

    assign f = part1 | part2;

endmodule