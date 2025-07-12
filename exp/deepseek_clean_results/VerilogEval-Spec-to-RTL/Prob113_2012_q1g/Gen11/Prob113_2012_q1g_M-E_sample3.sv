module TopModule(
    input [3:0] x,
    output f
);
    // Row decoders
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] &  x[2];
    wire row11 =  x[3] &  x[2];
    wire row10 =  x[3] & ~x[2];
    
    // Column decoders
    wire col00 = ~x[1] & ~x[0];
    wire col01 = ~x[1] &  x[0];
    wire col11 =  x[1] &  x[0];
    wire col10 =  x[1] & ~x[0];
    
    // Output logic based on K-map
    assign f = (row00 & (col00 | col10)) |  // Row 00: cols 00,10
               (row11 & ~col10) |           // Row 11: all cols except 10
               (row10 & (col00 | col01 | col10)); // Row 10: cols 00,01,10
endmodule