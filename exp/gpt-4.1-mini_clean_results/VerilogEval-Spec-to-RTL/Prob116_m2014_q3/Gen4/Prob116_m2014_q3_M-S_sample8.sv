module TopModule(
    input  [3:0] x,  // x[3], x[2], x[1], x[0]
    output      f
);

    // From the Karnaugh map:
    // Rows: x[3]x[0]
    // Columns: x[1]x[2]
    //
    // After simplification, one minimal sum-of-products is:
    // f = x[3]x[0] + x[3]x[1] + x[2]x[1]'x[0]' 
    //
    // The third term covers some 1s in row 01 (x[3]x[0] = 0 1) and columns with x[1]=0,x[2]=1.
    //
    // Alternatively, a fully simplified expression is:
    // f = (x[3] & x[0]) | (x[3] & x[1]) | (x[2] & ~x[1] & ~x[0])

    assign f = (x[3] & x[0]) | (x[3] & x[1]) | (x[2] & ~x[1] & ~x[0]);

endmodule