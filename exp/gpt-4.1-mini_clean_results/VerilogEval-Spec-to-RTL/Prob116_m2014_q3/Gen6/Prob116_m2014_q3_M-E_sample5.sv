module TopModule(
    input  [3:0] x,
    output      f
);

    // Assign inputs to named wires for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // From Karnaugh map interpretation (rows: x3 x0; columns: x1 x2):

    // Minterm 1: row=01 (x3=0,x0=1), col=11 (x1=1,x2=1): ~x3 & x0 & x1 & x2
    wire m1 = (~x3) & x0 & x1 & x2;

    // Minterm 2 and 3: rows=11 or 10 (x3=1), cols=00 or 01 (x1=0 or 1, x2=0),
    // which can be simplified to: x3 & ~x2
    wire m2 = x3 & (~x2);

    // Additional minterm from map (row=11,x0=1,col=01): 1
    // Actually covered by m2 already.

    // Additional minterm from row=10,x0=0,col=00 and 01 = 1 for both (map)
    // Also covered by m2.

    // There is one "1" at row=01,col=11 already in m1, and the rest covered by m2.

    // Combine minterms
    assign f = m1 | m2;

endmodule