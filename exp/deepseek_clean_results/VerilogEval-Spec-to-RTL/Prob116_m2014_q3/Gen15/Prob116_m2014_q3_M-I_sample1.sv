module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // Optimized single expression covering all required minterms
    assign f = (x[1] & x[3]) | (~x[0] & x[2]);
endmodule