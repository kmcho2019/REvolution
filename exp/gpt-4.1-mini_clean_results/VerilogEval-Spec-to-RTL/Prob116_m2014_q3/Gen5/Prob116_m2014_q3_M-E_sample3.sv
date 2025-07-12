module TopModule(
    input [3:0] x,
    output f
);
    // Map input bits to Karnaugh map bits:
    // row bits: x[3], x[4] → x[3], x[0]
    // col bits: x[1], x[2] → x[1], x[2]
    wire r1 = x[3];
    wire r0 = x[0];
    wire c1 = x[1];
    wire c0 = x[2];

    // From the Karnaugh map "1" entries:
    // Positions (row,col) with f=1:
    // (11,00) = (r1=1,r0=1, c1=0,c0=0) → r1 r0 !c1 !c0
    // (11,01) = (r1=1,r0=1, c1=0,c0=1) → r1 r0 !c1 c0
    // (10,00) = (r1=1,r0=0, c1=0,c0=0) → r1 !r0 !c1 !c0
    // (10,01) = (r1=1,r0=0, c1=0,c0=1) → r1 !r0 !c1 c0
    // (01,11) = (r1=0,r0=1, c1=1,c0=1) → !r1 r0 c1 c0
    // (11,01) and (11,00) and (10,00) and (10,01) suggest grouping on r1=1, c1=0
    // (01,11) is isolated
    // (11,00) and (11,01) can be combined: r1 r0 !c1
    // (10,00) and (10,01) can be combined: r1 !r0 !c1
    // Combined: r1 !c1
    // Additionally, (01,11) = !r1 r0 c1 c0

    // From this, the function can be expressed as:
    // f = (r1 & !c1) | (!r1 & r0 & c1 & c0)

    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & c0);

endmodule