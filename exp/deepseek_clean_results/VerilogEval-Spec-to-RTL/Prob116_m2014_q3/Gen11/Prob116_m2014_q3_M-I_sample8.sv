module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Direct implementation from optimized K-map analysis
    assign f = (x[3] & x[2]) |                     // x[3]x[4]=11 cases
               (x[3] & ~x[2] & (x[1] | x[0])) |    // x[3]x[4]=10 cases
               (~x[3] & x[2] & x[1] & x[0]);       // x[3]x[4]=01 and x[1]x[2]=11 case
endmodule