module TopModule(
    input  [3:0] x,
    output       f
);

    // Directly assign f using a minimal sum-of-products expression derived from K-map:
    // f = (~x3 & ~x1) | (~x3 & x2 & ~x0) | (x3 & x2 & ~x0) | (x3 & x2 & x1) | (x3 & ~x2 & ~x0) | (~x3 & ~x2 & ~x0)
    // Simplifying and combining terms to minimal:
    assign f = (~x[3] & ~x[1]) | (~x[3] & x[2] & ~x[0]) | (x[3] & x[2] & (~x[0] | x[1])) | (x[3] & ~x[2] & ~x[0]) | (~x[3] & ~x[2] & ~x[0]);

endmodule