module TopModule (
    input  [3:0] x, // Inputs: x[3], x[2], x[1], x[0]
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Minterms where f=1 (from K-map):
    // (x3,x2,x1,x0):
    // 1100, 1101, 0111, 1000, 1001
    //
    // Simplify expression by factoring:
    // f = (x3 & ~x2 & ~x1) | (x3 & x2 & x1) | (~x3 & x2 & x1)
    // Note: From the minterms, group terms:
    // 1100 (x3 & x2 & ~x1 & ~x0) and 1101 (x3 & x2 & ~x1 & x0)
    //   => x3 & x2 & ~x1
    // 0111 (~x3 & x2 & x1 & x0)
    // 1000 (x3 & ~x2 & ~x1 & ~x0) and 1001 (x3 & ~x2 & ~x1 & x0)
    //   => x3 & ~x2 & ~x1
    //
    // Combine minterms:
    // f = x3 & ~x1 & (x2 | ~x2) | x2 & x1 & (~x3 | 1)
    // Since (x2 | ~x2) = 1, (~x3 | 1) = 1
    // => f = x3 & ~x1 | x2 & x1

    assign f = (x3 & ~x1) | (x2 & x1);

endmodule