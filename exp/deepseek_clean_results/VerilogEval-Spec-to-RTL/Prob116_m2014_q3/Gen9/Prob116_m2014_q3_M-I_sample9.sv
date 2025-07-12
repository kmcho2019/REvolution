module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    assign f = (x[3] & x[2]) |  // Covers all cases when x[3]x[4] = 11
               (~x[3] & x[2] & ~x[0]) |  // Covers x[3]x[4] = 01 cases where f=1
               (x[3] & ~x[2] & ~x[1]);  // Covers x[3]x[4] = 10 cases where f=1
endmodule