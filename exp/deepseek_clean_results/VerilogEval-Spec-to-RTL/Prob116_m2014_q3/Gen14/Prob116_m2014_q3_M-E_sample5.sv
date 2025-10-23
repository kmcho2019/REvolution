module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Row 00: x[3]=0, x[4]=0
    wire row00_out = ~x[1] & ~x[0];  // Only 0 in column 01 matters
    
    // Row 01: x[3]=0, x[4]=1
    wire row01_out = (x[1] & x[0]) | (~x[1] & ~x[0]);
    
    // Row 11: x[3]=1, x[4]=1
    wire row11_out = ~x[0] | x[1];  // Covers all 1's in this row
    
    // Row 10: x[3]=1, x[4]=0
    wire row10_out = x[1];  // Covers all 1's in this row
    
    // 4:1 MUX implementation
    assign f = (~x[3] & ~x[4]) ? row00_out :
               (~x[3] &  x[4]) ? row01_out :
               ( x[3] &  x[4]) ? row11_out :
               row10_out;
endmodule