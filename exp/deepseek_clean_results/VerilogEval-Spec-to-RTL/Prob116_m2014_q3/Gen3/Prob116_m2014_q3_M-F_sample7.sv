module TopModule(
    input [3:0] x,
    output f
);
    assign f = (x[3] & ~x[1]) |  // Covers x[3]x[0]=11/10 with x[1]x[2]=00/01
               (~x[3] & x[0] & x[1] & x[2]);  // Covers x[3]x[0]=01 with x[1]x[2]=11
endmodule