module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Row decoder (x[3:4])
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] &  x[2];
    wire row11 =  x[3] &  x[2];
    wire row10 =  x[3] & ~x[2];

    // Column decoder (x[1:0])
    wire col00 = ~x[1] & ~x[0];
    wire col01 = ~x[1] &  x[0];
    wire col11 =  x[1] &  x[0];
    wire col10 =  x[1] & ~x[0];

    // Implement K-map using decoded signals
    assign f = (row00 & (col01 ? 1'b0 : 1'b1)) |  // row00: d,0,d,d
               (row01 & ((col00 | col10) ? 1'b0 : (col11 ? 1'b1 : 1'b0))) |  // row01: 0,d,1,0
               (row11 & ((col00 | col01) ? 1'b1 : 1'b0)) |  // row11: 1,1,d,d
               (row10 & ((col00 | col01) ? 1'b1 : (col11 ? 1'b0 : 1'b1)));  // row10: 1,1,0,d
endmodule