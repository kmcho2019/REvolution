module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |  // Covers 0000 and 0010
                (x[3] & ~x[1]) |          // Covers 1100, 1101, 1000, 1001
                (x[3] & ~x[2] & x[1] & ~x[0]);  // Covers 1010
endmodule