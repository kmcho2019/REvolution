module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[1] & ~x[0]) |  // 0000
               (~x[3] & ~x[2] & x[1] & ~x[0])  |  // 0010
               (x[3] & x[2] & ~x[1])           |  // 11x0 and 11x1
               (x[3] & ~x[2] & (~x[0] | ~x[1]));  // 10 cases
endmodule