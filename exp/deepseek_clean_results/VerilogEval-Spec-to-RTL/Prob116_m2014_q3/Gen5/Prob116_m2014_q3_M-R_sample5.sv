module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0]
    output f
);
    // Refactored logic with proper K-map implementation
    assign f = (~x[3] & x[1] & x[2]) |          // Covers x3x0=01, x1x2=11
               (x[3] & ~x[0] & ~x[1] & ~x[2]) | // Covers x3x0=10, x1x2=00
               (x[3] & x[0] & ~x[2]) |          // Covers x3x0=11, x1x2=00 and 01
               (x[3] & x[0] & ~x[1]);           // Covers x3x0=11, x1x2=01 and x3x0=10 cases
endmodule