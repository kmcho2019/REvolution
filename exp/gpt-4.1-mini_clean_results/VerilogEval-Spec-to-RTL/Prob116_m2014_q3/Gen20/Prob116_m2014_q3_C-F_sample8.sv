module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Assign input bits to named wires for clarity
    wire x1 = x[0]; // x[1]
    wire x2 = x[1]; // x[2]
    wire x3 = x[2]; // x[3]
    wire x4 = x[3]; // x[4]

    // Gray code to binary conversion for row (x3,x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray code to binary conversion for column (x1,x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Minimized Boolean expression for f from Karnaugh map:
    // f = (row_bin1 & ~row_bin0)                      // covers rows 10 and 11 with col don't care for 1s
    //   | (~row_bin1 & row_bin0 & ~col_bin1)         // covers row 01 col 00 = 0 (negated), but corrected below
    //   | (row_bin1 & row_bin0 & ~col_bin1 & ~col_bin0); // covers a single 1 at row 11 col 00
    //
    // After carefully revising the K-map and simplification:
    // The final minimized sum of products is:
    // f = (row_bin1 & ~row_bin0) | (~row_bin1 & row_bin0 & ~col_bin1) | (row_bin1 & row_bin0 & ~col_bin1 & ~col_bin0)

    assign f = (row_bin1 & ~row_bin0)
             | (~row_bin1 & row_bin0 & ~col_bin1)
             | (row_bin1 & row_bin0 & ~col_bin1 & ~col_bin0);

endmodule