module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From Gray code to binary for rows (x3, x4)
    wire r1 = x3;
    wire r0 = x3 ^ x4;

    // From Gray code to binary for cols (x1, x2)
    wire c1 = x1;
    wire c0 = x1 ^ x2;

    // Define minterms where output is 1 (based on the Karnaugh map analysis)
    // Minterms (row,col) in binary after Gray-to-binary decoding:
    // Rows: r1 r0, Cols: c1 c0
    // 1000(8): r1=1,r0=0,c1=0,c0=0 -> row=2, col=0
    // 1001(9): r1=1,r0=0,c1=0,c0=1 -> row=2, col=1
    // 1100(12): r1=1,r0=1,c1=0,c0=0 -> row=3, col=0
    // 1101(13): r1=1,r0=1,c1=0,c0=1 -> row=3, col=1
    // 0110(6): r1=0,r0=1,c1=1,c0=0 -> row=1, col=2
    // 1000..1101 correspond to minterms where output=1

    // From Boolean minimization we get:
    // f = r1 & ~r0 | r1 & ~c1 | (~r1) & r0 & c1

    assign f = (r1 & ~r0) | (r1 & ~c1) | (~r1 & r0 & c1);

endmodule