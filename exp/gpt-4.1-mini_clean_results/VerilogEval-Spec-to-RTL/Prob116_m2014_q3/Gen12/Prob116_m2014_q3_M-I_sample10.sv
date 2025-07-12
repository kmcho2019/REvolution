module TopModule(
    input  [3:0] x,
    output      f
);
    // Map inputs:
    // x[0] = x[1] in problem notation
    // x[1] = x[2]
    // x[2] = x[3]
    // x[3] = x[4]

    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // Minimized expression derived from Karnaugh map:
    assign f = (x3 & ~x2)        // row=10, columns with 1s
             | (x3 & x1)         // row=11, columns with 1s
             | (~x3 & x2 & x0)   // row=01 and 00 with conditions
             | (~x3 & ~x2 & x1 & x0); // covering lower left don't-care turned 1

endmodule