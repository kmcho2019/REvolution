module TopModule(
    input [3:0] x,
    output f
);
    wire row00, row01, row11, row10;
    
    // Row detection
    assign row00 = ~x[3] & ~x[2];
    assign row01 = ~x[3] & x[2];
    assign row11 = x[3] & x[2];
    assign row10 = x[3] & ~x[2];
    
    // Row-specific conditions
    wire row00_cond = (~x[1] & ~x[0]) | (x[1] & ~x[0]);  // x[1:0] is 00 or 10
    wire row11_cond = ~(x[1] & ~x[0]);                   // not x[1:0]=10
    wire row10_cond = (~x[1] & ~x[0]) | (~x[1] & x[0]) | (x[1] & ~x[0]);  // x[1:0] is 00,01, or 10
    
    // Final output
    assign f = (row00 & row00_cond) |
               (row11 & row11_cond) |
               (row10 & row10_cond);
endmodule