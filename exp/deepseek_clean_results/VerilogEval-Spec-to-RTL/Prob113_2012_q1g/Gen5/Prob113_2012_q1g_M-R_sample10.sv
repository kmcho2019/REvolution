module TopModule(
    input [3:0] x,
    output f
);
    // Row detection remains the same
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] & x[2];
    wire row11 = x[3] & x[2];
    wire row10 = x[3] & ~x[2];
    
    // Precise row conditions based on K-map
    wire row00_f = (~x[1] & ~x[0]) | (x[1] & ~x[0]);  // x[1:0]=00 or 10
    wire row11_f = ~(~x[1] & x[0]);                   // Not x[1:0]=10
    wire row10_f = (~x[1]) | (x[1] & ~x[0]);          // x[1:0]=00,01, or 10
    
    // Final output with all cases
    assign f = (row00 & row00_f) |
               (row11 & row11_f) |
               (row10 & row10_f);
               // row01 case is implicitly 0
endmodule