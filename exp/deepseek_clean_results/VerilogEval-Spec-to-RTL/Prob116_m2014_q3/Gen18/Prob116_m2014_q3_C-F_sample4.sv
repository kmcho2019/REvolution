module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Optimized implementation using minimal logic operations
    // f = (~x[0] & x[2]) | (x[0] & x[1] & x[3])
    assign f = x[0] ? (x[1] & x[3]) : x[2];
endmodule