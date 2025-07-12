module TopModule(
    input [3:0] x,
    output f
);
    wire row00, row01, row11, row10;
    
    // Decode x[3:2] into separate row enables
    assign row00 = ~x[3] & ~x[2];
    assign row01 = ~x[3] & x[2];
    assign row11 = x[3] & x[2];
    assign row10 = x[3] & ~x[2];
    
    // Implement each row's specific logic
    wire row00_out = row00 & ((~x[1] & ~x[0]) | (x[1] & ~x[0]));  // 00 or 10
    wire row01_out = 1'b0;                                       // always 0
    wire row11_out = row11 & ((~x[1] & ~x[0]) | (~x[1] & x[0]) | (x[1] & x[0])); // 00,01,11
    wire row10_out = row10 & ((~x[1] & ~x[0]) | (x[1] & ~x[0])); // 00 or 10
    
    // Combine all row outputs
    assign f = row00_out | row01_out | row11_out | row10_out;
endmodule