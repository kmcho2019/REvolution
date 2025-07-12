module TopModule(
    input [3:0] x,
    output f
);
    // Decode row selection
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] & x[2];
    wire row11 = x[3] & x[2];
    wire row10 = x[3] & ~x[2];

    // Implement each row's pattern
    wire f_row00 = row00 & (~x[1] | ~x[0]);  // 00 or 10 in columns
    wire f_row01 = 1'b0;                     // All 0s in this row
    wire f_row11 = row11 & (x[1] | x[0]);    // All except 10 in columns
    wire f_row10 = row10 & (~x[1] | x[0]);   // 00, 01, or 10 in columns

    // Combine all row outputs
    assign f = f_row00 | f_row11 | f_row10;
endmodule