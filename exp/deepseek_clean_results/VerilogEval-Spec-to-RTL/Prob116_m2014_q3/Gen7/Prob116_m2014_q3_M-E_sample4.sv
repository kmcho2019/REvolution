module TopModule(
    input [3:0] x,  // x[3]x[0]x[1]x[2] mapping (assuming x[4] was typo for x[0])
    output f
);
    // Row and column decoding
    wire row_00 = ~x[3] & ~x[0];
    wire row_01 = ~x[3] & x[0];
    wire row_11 = x[3] & x[0];
    wire row_10 = x[3] & ~x[0];
    
    wire col_00 = ~x[1] & ~x[2];
    wire col_01 = ~x[1] & x[2];
    wire col_11 = x[1] & x[2];
    wire col_10 = x[1] & ~x[2];
    
    // Implement truth table with priority encoding
    // Mandatory 0s and 1s from K-map take precedence
    assign f = (row_00 & col_01) ? 1'b0 :  // 00_01 = 0
               (row_01 & col_00) ? 1'b0 :   // 01_00 = 0
               (row_01 & col_11) ? 1'b1 :   // 01_11 = 1
               (row_01 & col_10) ? 1'b0 :   // 01_10 = 0
               (row_11 & col_00) ? 1'b1 :   // 11_00 = 1
               (row_11 & col_01) ? 1'b1 :   // 11_01 = 1
               (row_10 & col_00) ? 1'b1 :   // 10_00 = 1
               (row_10 & col_01) ? 1'b1 :   // 10_01 = 1
               (row_10 & col_11) ? 1'b0 :   // 10_11 = 0
               1'b0;  // All other cases (don't-cares set to 0)
endmodule