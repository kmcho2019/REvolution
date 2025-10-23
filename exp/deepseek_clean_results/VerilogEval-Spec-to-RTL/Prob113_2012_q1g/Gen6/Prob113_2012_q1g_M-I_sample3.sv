module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |          // x3'x2'x0'
               (x[3] & x[2] & ~x[1]) |            // x3x2x1'
               (x[3] & x[2] & x[1] & x[0]) |     // x3x2x1x0
               (x[3] & ~x[2] & ~x[1]) |           // x3x2'x1'
               (x[3] & ~x[2] & x[1] & ~x[0]);     // x3x2'x1x0'
endmodule