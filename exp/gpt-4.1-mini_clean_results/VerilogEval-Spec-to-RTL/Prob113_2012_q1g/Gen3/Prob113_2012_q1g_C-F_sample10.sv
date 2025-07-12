module TopModule(
    input  [3:0] x,
    output       f
);
    wire nx0 = ~x[0];
    wire nx1 = ~x[1];
    wire nx2 = ~x[2];
    wire nx3 = ~x[3];

    // Implement minimal sum-of-products expression derived from K-map with inputs reordered as in examples
    assign f = (nx2 & nx3 & nx1)                      // ~x[2] & ~x[3] & ~x[1]
             | (nx2 & nx3 & x[0] & nx1)              // ~x[2] & ~x[3] & x[0] & ~x[1]
             | (x[2] & nx0)                          // x[2] & ~x[0]
             | (x[2] & x[3] & x[1]);                 // x[2] & x[3] & x[1]

endmodule