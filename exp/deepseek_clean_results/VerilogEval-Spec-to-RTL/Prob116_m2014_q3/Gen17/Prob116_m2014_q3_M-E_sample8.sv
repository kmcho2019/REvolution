module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // 4-to-1 MUX with x[3] and x[4] as select lines
    assign f = (~x[3] & ~x[4] & ~x[1]) |  // Row 00, column 01 (0)
               (~x[3] & x[4] & ((x[1] & x[0]) | (~x[1] & ~x[0]))) |  // Row 01
               (x[3] & ~x[4] & (x[1] | x[0])) |  // Row 10
               (x[3] & x[4] & x[1]);  // Row 11 (simplified using don't-cares)
endmodule