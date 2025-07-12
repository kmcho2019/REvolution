module TopModule (
    input  [3:0] x,  // x = {x4,x3,x2,x1} = x[3], x[2], x[1], x[0]
    output      f
);
    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];

    // Karnaugh map minterms (treating don't-cares as zeros or ones to simplify):
    // From the map and grouping minterms, the minimized expression is:
    // f = x4'x3 + x3x2 + x4x1'x2' + x4x3'x1

    // Simplify:
    // Terms:
    // 1) x4' x3
    // 2) x3 x2
    // 3) x4 x1' x2'
    // 4) x4 x3' x1

    wire term1 = (~x4) & x3;
    wire term2 = x3 & x2;
    wire term3 = x4 & (~x1) & (~x2);
    wire term4 = x4 & (~x3) & x1;

    assign f = term1 | term2 | term3 | term4;

endmodule