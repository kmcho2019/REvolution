module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |                     // 0000 or 0010
               (x[3] & x[2] & (x[1] | ~x[0])) |              // 1100,1101,1111
               (x[3] & ~x[2] & ~(x[1] & x[0]));              // 1000,1001,1010
endmodule