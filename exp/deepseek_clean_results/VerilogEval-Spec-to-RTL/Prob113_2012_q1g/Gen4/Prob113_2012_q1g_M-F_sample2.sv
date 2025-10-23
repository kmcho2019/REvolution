module TopModule(
    input [3:0] x,
    output f
);
    wire row00, row10, row11;
    wire col00_10, col00_01_10, col00_01_11;
    
    // Row conditions
    assign row00 = ~x[3] & ~x[2];  // x[3:2] = 00
    assign row10 = x[3] & ~x[2];    // x[3:2] = 10
    assign row11 = x[3] & x[2];     // x[3:2] = 11
    
    // Column conditions
    assign col00_10 = (~x[1] & ~x[0]) | (x[1] & ~x[0]);  // x[1:0] = 00 or 10
    assign col00_01_10 = (~x[1] & ~x[0]) | (~x[1] & x[0]) | (x[1] & ~x[0]);  // x[1:0] = 00, 01, or 10
    assign col00_01_11 = (~x[1] & ~x[0]) | (~x[1] & x[0]) | (x[1] & x[0]);   // x[1:0] = 00, 01, or 11
    
    // Final output
    assign f = (row00 & col00_10) |        // Top row condition
               (row10 & col00_01_10) |     // Bottom row condition
               (row11 & col00_01_11);      // Third row condition
endmodule