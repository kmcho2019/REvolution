module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |  // Group 1
               (x[3] & x[2] & ~x[1]) |    // Group 2a
               (x[3] & x[2] & ~x[0]) |    // Group 2b
               (x[3] & ~x[2] & ~x[1]);    // Group 3
endmodule