module TopModule (
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (problem notation)
    output       f
);

    // Assign input bits for clarity using problem notation
    wire x1 = x[0]; // x[1]
    wire x2 = x[1]; // x[2]
    wire x3 = x[2]; // x[3]
    wire x4 = x[3]; // x[4]

    // Decode Gray-coded row (x3, x4) to binary:
    // Gray to binary: b1 = g1, b0 = g1 XOR g0
    wire row1 = x3;
    wire row0 = x3 ^ x4;

    // Decode Gray-coded column (x1, x2) to binary:
    wire col1 = x1;
    wire col0 = x1 ^ x2;

    // Minimized Boolean expression for f from map ones:
    // Ones at (row,col) binary coordinates:
    // (3,0), (3,1), (2,0), (2,1), (1,3)
    //
    // Using decoded bits:
    // 1) row=3 (11), col=0(00): row1&row0 & ~col1 & ~col0
    // 2) row=3 (11), col=1(01): row1&row0 & ~col1 &  col0
    // 3) row=2 (10), col=0(00): row1&~row0 & ~col1 & ~col0
    // 4) row=2 (10), col=1(01): row1&~row0 & ~col1 &  col0
    // 5) row=1 (01), col=3(11): ~row1&row0 & col1 & col0
    //
    // Factor common terms:
    // For (1)-(4):
    // row1 & ~col1 & ( (row0 & ~col0) | (row0 & col0) | (~row0 & ~col0) | (~row0 & col0) )
    // The expression inside () simplifies to (row0 OR ~row0) & (col0 OR ~col0) = 1 (all cases for col0 and row0)
    // So (1)-(4) reduce to row1 & ~col1
    // Thus f = (row1 & ~col1) | (~row1 & row0 & col1 & col0);

    assign f = (row1 & ~col1) | (~row1 & row0 & col1 & col0);

endmodule