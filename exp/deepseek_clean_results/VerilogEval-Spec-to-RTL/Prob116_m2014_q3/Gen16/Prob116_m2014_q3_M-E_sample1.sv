module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // Row selection based on x[3]x[4] (x[3:2] in our mapping)
    wire row0 = ~x[3] & ~x[2];  // 00 row
    wire row1 = ~x[3] &  x[2];  // 01 row
    wire row2 =  x[3] &  x[2];  // 11 row
    wire row3 =  x[3] & ~x[2];  // 10 row

    // Column logic (x[1]x[0] in our mapping)
    wire col0 = ~x[1] & ~x[0];
    wire col1 = ~x[1] &  x[0];
    wire col2 =  x[1] &  x[0];
    wire col3 =  x[1] & ~x[0];

    // Row-specific logic
    wire row0_out = col1 ? 1'b0 : 1'bx;  // Only care about col1=0
    wire row1_out = (col0 | col3) ? 1'b0 : (col2 ? 1'b1 : 1'bx);
    wire row2_out = (col0 | col1) ? 1'b1 : 1'bx;
    wire row3_out = col2 ? 1'b0 : 1'b1;  // All other cases are 1

    // Final output selection
    assign f = row0 ? row0_out :
               row1 ? row1_out :
               row2 ? row2_out :
               row3 ? row3_out : 1'bx;
endmodule