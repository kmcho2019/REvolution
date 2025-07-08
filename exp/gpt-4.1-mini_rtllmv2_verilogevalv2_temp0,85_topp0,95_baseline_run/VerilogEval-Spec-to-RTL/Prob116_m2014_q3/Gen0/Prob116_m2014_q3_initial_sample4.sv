module TopModule(
    input [3:0] x,
    output f
);
    // Assign bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // f = x4 & ~x2 | ~x4 & x3 & x2 & x1
    assign f = (x4 & ~x2) | (~x4 & x3 & x2 & x1);

endmodule