module TopModule(
    input [3:0] x,
    output f
);
    wire row00, row01, row11, row10;
    wire pattern00, pattern01, pattern11, pattern10;
    
    // Row decoders
    assign row00 = ~x[3] & ~x[2];
    assign row01 = ~x[3] & x[2];
    assign row11 = x[3] & x[2];
    assign row10 = x[3] & ~x[2];
    
    // Column patterns (corrected based on K-map)
    assign pattern00 = ~x[0];  // For row00: 00 and 10 (simplifies to ~x[0])
    assign pattern01 = 1'b0;   // For row01: always 0
    assign pattern11 = ~x[1] | x[0];  // For row11: 00, 01, or 11
    assign pattern10 = ~x[1] | ~x[0]; // For row10: 00, 01, or 10
    
    // Final output
    assign f = (row00 & pattern00) |
               (row01 & pattern01) |
               (row11 & pattern11) |
               (row10 & pattern10);
endmodule