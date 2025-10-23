module TopModule(
    input [3:0] x,
    output f
);
    // According to the feedback and corrected interpretation:
    // Row bits: x[3], x[0]
    // Column bits: x[1], x[2]
    wire r1 = x[3];
    wire r0 = x[0];
    wire c1 = x[1];
    wire c0 = x[2];

    // Karnaugh map (rows=r1r0, cols=c1c0):
    //        00  01  11  10 (c1c0)
    // 00 |  d | 0 | d | d |  (r1r0=00)
    // 01 |  0 | d | 1 | 0 |  (r1r0=01)
    // 11 |  1 | 1 | d | d |  (r1r0=11)
    // 10 |  1 | 1 | 0 | d |  (r1r0=10)

    // List all minterms where f=1:

    // r1r0 c1c0 val
    // 11   00   1  -> r1=1,r0=1,c1=0,c0=0
    // 11   01   1  -> r1=1,r0=1,c1=0,c0=1
    // 01   11   1  -> r1=0,r0=1,c1=1,c0=1
    // 10   00   1  -> r1=1,r0=0,c1=0,c0=0
    // 10   01   1  -> r1=1,r0=0,c1=0,c0=1

    // Group 1: r1=1, c1=0 covers (11,00), (11,01), (10,00), (10,01)
    // Expression: r1 & ~c1

    // Remaining minterm: (01,11) -> ~r1 & r0 & c1 & c0

    // Final simplified function:
    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & c0);

endmodule