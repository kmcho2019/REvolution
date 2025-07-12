module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0]
    output f
);
    // Corrected logic based on proper K-map interpretation
    assign f = x[3] |                         // Covers all cases where x[3]=1
               (~x[1] & ~x[2] & ~x[0]) |      // Covers x3x0=00, x1x2=01 (0->1 via don't-care)
               (x[1] & x[2] & x[0]);          // Covers x3x0=01, x1x2=11
endmodule