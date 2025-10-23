module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Minimized expression from K-map:
    // f = x4 x3' + x4' x3 x2 + x3 x2' x1'
    // Explanation:
    // - The group of 1s in rows 11 and 10, columns 00 and 01 yields x4 x3'
    // - The group in row 01 column 11 yields x4' x3 x2
    // - The group in row 11 column 01 yields x3 x2' x1'
    assign f = (x4 & ~x3) | (~x4 & x3 & x2) | (x3 & ~x2 & ~x1);

endmodule