module TopModule (
    input  [3:0] x, // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem notation)
    output      f
);

    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // The Karnaugh map cells with output '1' from the problem:
    // row = x3 x4 (Gray), col = x1 x2 (Gray)
    // Given 1's at:
    // (11,00) => x3=1,x4=1,x1=0,x2=0
    // (11,01) => x3=1,x4=1,x1=0,x2=1
    // (10,00) => x3=1,x4=0,x1=0,x2=0
    // (10,01) => x3=1,x4=0,x1=0,x2=1
    // (01,11) => x3=0,x4=1,x1=1,x2=1

    // We directly check these conditions and output 1 if any matches, else 0.

    assign f = 
           (x3 &  x4 & ~x1 & ~x2)  // (11,00)
        |  (x3 &  x4 & ~x1 &  x2)  // (11,01)
        |  (x3 & ~x4 & ~x1 & ~x2)  // (10,00)
        |  (x3 & ~x4 & ~x1 &  x2)  // (10,01)
        |  (~x3 & x4 &  x1 &  x2); // (01,11)

endmodule