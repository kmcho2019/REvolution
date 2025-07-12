module TopModule(
    input  [3:0] x,
    output      f
);
    wire term1, term2;

    assign term1 = (~x[3]) & x[2] & x[1] & x[0];
    assign term2 = x[3] & (~x[1]);

    assign f = term1 | term2;

endmodule