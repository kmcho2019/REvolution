module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Optimized single-term solution covering all required 1s
    assign f = (x[2] & ~x[0]) | (x[3] & x[1]);
endmodule