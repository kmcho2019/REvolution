module TopModule(
    input  [3:0] x,
    output      f
);
    wire n_x0 = ~x[0];
    wire n_x1 = ~x[1];
    wire n_x3 = ~x[3];

    wire term1 = n_x1 & n_x3;                  // ~x[1] & ~x[3]
    wire term2 = x[2] & x[3] & (n_x0 | x[1]); // x[2] & x[3] & (~x[0] | x[1])

    assign f = term1 | term2;
endmodule