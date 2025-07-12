module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // x[3] is x[4] in K-map, x[2] is x[3] in K-map, x[1] is x[2], x[0] is x[1]
    assign f = (x[2] & ~x[0]) |  // Covers x[4]x[3]=11/10 with x[2]x[1]=00/01
               (~x[2] & x[3] & x[0] & x[1]);  // Covers x[4]x[3]=01 with x[2]x[1]=11
endmodule