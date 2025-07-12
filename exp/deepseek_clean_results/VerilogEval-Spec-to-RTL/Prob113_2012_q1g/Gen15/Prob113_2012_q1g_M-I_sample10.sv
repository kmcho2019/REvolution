module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & (~x[1] | ~x[0])) |  // x[3:2]=00, x[1:0]=00 or 10
               (x[3] & x[2] & x[0]) |                // x[3:2]=11, x[1:0]=00,01,11
               (x[3] & ~x[2] & (x[1] | ~x[0]));      // x[3:2]=10, x[1:0]=00,01,10
endmodule