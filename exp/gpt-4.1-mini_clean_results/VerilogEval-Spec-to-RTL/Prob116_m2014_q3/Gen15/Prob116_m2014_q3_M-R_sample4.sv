module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (Gray code)
    output        f
);

    // Assign individual Gray-coded inputs
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Decode Gray-coded row index (x3,x4) to binary
    wire r1 = x3;
    wire r0 = x3 ^ x4;

    // Decode Gray-coded column index (x1,x2) to binary
    wire c1 = x1;
    wire c0 = x1 ^ x2;

    // From the Karnaugh map, derive the minimal expression for f
    // Let's rewrite Karnaugh map entries with rows=r1r0, cols=c1c0:
    // rows/cols: 00 01 11 10
    // 00: d  0  d  d
    // 01: 0  d  1  0
    // 11: 1  1  d  d
    // 10: 1  1  0  d
    //
    // Choosing don't-care as 0 where convenient.
    //
    // Sum of minterms for f=1 (from the map):
    // (r,c) = (01,11), (11,00), (11,01), (10,00), (10,01)
    //
    // Let's write minterms in terms of r1,r0,c1,c0:
    // (0,1),(1,1),(1,0) for rows and corresponding cols:
    // (r1 r0) (c1 c0)
    // 01(0 1), 11(1 1) -> minterm (r1=0,r0=1,c1=1,c0=1)
    // 11(1 1), 00(0 0)
    // 11(1 1), 01(0 1)
    // 10(1 0), 00(0 0)
    // 10(1 0), 01(0 1)
    //
    // Derive minimal SOP:
    // Group1: row11 (r1=1,r0=1) and col00 or 01 -> r1 & r0 & ~c1
    // Group2: row10 (r1=1,r0=0) and col00 or 01 -> r1 & ~r0 & ~c1
    // Group3: row01(0 1) and col11(1 1) -> ~r1 & r0 & c1 & c0
    //
    // Combine group1 and group2: r1 & ~c1 (since r0=0 or 1)
    // So final f = (r1 & ~c1) | (~r1 & r0 & c1 & c0)
    //
    // Implement expression

    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & c0);

endmodule