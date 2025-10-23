module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & x[0] & x[1] & x[2]) |  // x[3]x[0]=01 and x[1]x[2]=11
               (x[3] & x[0] & ~x[2]) |         // x[3]x[0]=11 and x[1]x[2]=01
               (x[3] & ~x[0] & ~x[1]);         // x[3]x[0]=10 and x[1]x[2]=00 or 01
endmodule