module TopModule(
    input [3:0] x,
    output f
);
    wire left_right_col;  // x[3:2] is 00 or 10
    wire middle_rows;     // x[3:2] is 11
    wire lr_condition;    // x[1:0] is 00 or 10
    
    // Detect left and right columns (00 or 10)
    assign left_right_col = (~x[3] & ~x[2]) | (x[3] & ~x[2]);
    
    // Detect middle rows (11)
    assign middle_rows = x[3] & x[2];
    
    // Condition for left/right columns
    assign lr_condition = (~x[1] & ~x[0]) | (x[1] & ~x[0]);
    
    // Final output
    assign f = (left_right_col & lr_condition) |       // Left/right columns with x[1:0] condition
               (middle_rows & (x[1] | ~x[0]));         // Middle rows excluding x[1:0]=10
endmodule