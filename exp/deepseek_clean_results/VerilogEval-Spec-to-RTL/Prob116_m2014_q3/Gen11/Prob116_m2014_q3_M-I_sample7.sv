module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Optimized direct implementation
    assign f = (~x[1] & x[3]) |         // Covers x[4]x[3]=11/10 when x[2]x[1]=00/01
                (x[0] & x[1] & x[3]) |   // Covers x[4]x[3]=01 when x[2]x[1]=11
                (~x[2] & x[0] & x[1]);    // Covers remaining cases when x[2]=0
endmodule