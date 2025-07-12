module TopModule (
    input  [3:0] x,  // x[3]=x3, x[2]=x2, x[1]=x1, x[0]=x0
    output       f
);
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Intermediate terms corresponding to minterms from the K-map
    wire term1 = x3 & x2 & ~x1;          // covers 1100, 1101 (x0=0 or 1)
    wire term2 = x3 & ~x2 & ~x1;         // covers 1000, 1001 (x0=0 or 1)
    wire term3 = ~x3 & x2 & x1 & x0;     // covers 0111
    // term4 isn't needed separately since term2 covers both 1000 and 1001 already

    // Final output is OR of all minterms
    assign f = term1 | term2 | term3;

endmodule