module TopModule(
    input  [3:0] x,
    output       f
);
    // Directly extract bits
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Implement the optimized logic directly without intermediate wires for complements used only once

    // f = (~x3 & ( ~x1 | (x2 & ~x0) )) | (x3 & x2 & (~x0 | x1))
    assign f = (~x3 & (~x1 | (x2 & ~x0))) | (x3 & x2 & (~x0 | x1));

endmodule