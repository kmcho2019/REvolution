module TopModule(
    input [3:0] x,  // x[3:4] are rows, x[1:2] are columns
    output f
);
    // Row decoder (x[3:4])
    wire row_00 = ~x[3] & ~x[2];
    wire row_01 = ~x[3] &  x[2];
    wire row_11 =  x[3] &  x[2];
    wire row_10 =  x[3] & ~x[2];

    // Column decoder (x[1:0])
    wire col_00 = ~x[1] & ~x[0];
    wire col_01 = ~x[1] &  x[0];
    wire col_11 =  x[1] &  x[0];
    wire col_10 =  x[1] & ~x[0];

    // Output selection logic
    wire case1 = row_00 & (col_01);  // Force 0 when x[3:4]=00 and x[1:0]=01
    wire case2 = row_01 & (col_00 | col_10);  // Force 0 when x[3:4]=01 and x[1:0]=00 or 10
    wire case3 = row_01 & col_11;   // Force 1 when x[3:4]=01 and x[1:0]=11
    wire case4 = row_11 & (col_00 | col_01);  // Force 1 when x[3:4]=11 and x[1:0]=00 or 01
    wire case5 = row_10 & (col_00 | col_01);  // Force 1 when x[3:4]=10 and x[1:0]=00 or 01
    wire case6 = row_10 & col_10;    // Force 0 when x[3:4]=10 and x[1:0]=10

    // Priority encoder (case3 has highest priority)
    assign f = case3 ? 1'b1 :
               case4 ? 1'b1 :
               case5 ? 1'b1 :
               case6 ? 1'b0 :
               case1 ? 1'b0 :
               case2 ? 1'b0 :
               1'b0;  // Default case (don't cares set to 0)
endmodule