module TopModule(
    input  [3:0] x,
    output f
);
    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // Simplified boolean expression from K-map analysis
    assign f = (~x1) | (x2 & ~x3) | (x2 & x3 & x1);

endmodule