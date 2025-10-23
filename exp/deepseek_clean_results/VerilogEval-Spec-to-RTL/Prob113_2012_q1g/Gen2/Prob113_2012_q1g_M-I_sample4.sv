module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |       // ~x3~x2~x0 (0,2)
               (x[3] & ~x[2] & ~x[1]) |        // x3~x2~x1 (8,9)
               (x[3] & ~x[2] & x[1]) |         // x3~x2x1 (10,11)
               (x[3] & x[2] & ~x[1]) |        // x3x2~x1 (12,13)
               (x[3] & x[2] & x[0]);           // x3x2x0 (13,15)
endmodule