module TopModule(
    input  [3:0] x, // x[3], x[2], x[1], x[0]
    output      f
);
    wire term1, term2, term3;

    // Map Karnaugh row variables: x[3], x[4] -> x[3], x[0]
    // Map Karnaugh col variables: x[1], x[2]

    assign term1 = (~x[3]) & x[0] & x[1] & x[2];
    assign term2 = x[3] & (~x[1]) & (~x[2]);
    assign term3 = x[3] & (~x[1]) & x[0];

    assign f = term1 | term2 | term3;

endmodule