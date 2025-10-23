module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[1]) |  // Covers 0000 and 0010
               (x[3] & x[2] & ~x[0])   |  // Covers 1100 and 1101
               (x[3] & ~x[2] & ~x[0]);    // Covers 1000 and 1001
endmodule