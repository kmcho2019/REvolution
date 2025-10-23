module TopModule(
    input  [3:0] x,
    output f
);
    // Using the simplified boolean expression from K-map grouping:
    // f = (~x[0] & ~x[1]) + (x[2] & x[3]) + (x[2] & ~x[3] & ~x[0]) + (~x[2] & ~x[3] & ~x[1])

    wire n_x0 = ~x[0];
    wire n_x1 = ~x[1];
    wire n_x2 = ~x[2];
    wire n_x3 = ~x[3];

    assign f = (n_x0 & n_x1)
             | (x[2] & x[3])
             | (x[2] & n_x3 & n_x0)
             | (n_x2 & n_x3 & n_x1);

endmodule