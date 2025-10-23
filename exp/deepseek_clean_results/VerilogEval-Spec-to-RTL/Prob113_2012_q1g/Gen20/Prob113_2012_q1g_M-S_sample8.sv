module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |           // row00 cases
               (x[3] & ~x[1] & ~x[0]) |            // common for row11 and row10
               (x[3] & x[2] & ~x[1]) |             // remaining row11 case
               (x[3] & ~x[2] & ~x[1]);             // remaining row10 case
endmodule