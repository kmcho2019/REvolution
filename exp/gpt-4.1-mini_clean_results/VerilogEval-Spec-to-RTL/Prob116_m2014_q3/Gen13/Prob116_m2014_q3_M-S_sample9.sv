module TopModule (
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Derived minimal sum-of-products from the Karnaugh map (with don't-cares chosen to simplify)
    // f = x3 & (~x4)         // row 10: covers minterms where f=1
    //   | x3 & x4            // row 11: covers minterms where f=1
    //   | (~x3) & x4 & x2    // from analysis of the map to cover remaining ones
    //   | x3 & x2            // from map entries with f=1 at (11,01) and (10,01)
    //
    // Combine terms and simplify:
    // f = x3 | (x4 & x2)

    assign f = x3 | (x4 & x2);

endmodule