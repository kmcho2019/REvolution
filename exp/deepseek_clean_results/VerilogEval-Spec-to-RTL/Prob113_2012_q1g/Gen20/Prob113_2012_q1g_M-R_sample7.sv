module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~(x[1] ^ x[0])) |  // x[3:2]=00 and x[1]=x[0]
               (x[3] & x[2] & (x[1] | ~x[0])) |    // x[3:2]=11 and not x[1:0]=10
               (x[3] & ~x[2] & (x[1] | x[0]));     // x[3:2]=10 and not x[1:0]=11
endmodule