module TopModule(
    input [3:0] x,
    output f
);
    // Correct bit mapping according to feedback:
    // Row bits: x[3], x[2]
    // Column bits: x[1], x[0]
    wire r1 = x[3];
    wire r0 = x[2];
    wire c1 = x[1];
    wire c0 = x[0];

    // Karnaugh map (row r1r0, col c1c0):
    //        00  01  11  10 (c1c0)
    // 00 |  d | 0 | d | d |   (r1r0=00)
    // 01 |  0 | d | 1 | 0 |   (r1r0=01)
    // 11 |  1 | 1 | d | d |   (r1r0=11)
    // 10 |  1 | 1 | 0 | d |   (r1r0=10)

    // List all minterms where f=1:

    // r1r0 c1c0 value
    // 11   00   1  -> r1=1, r0=1, c1=0, c0=0
    // 11   01   1  -> r1=1, r0=1, c1=0, c0=1
    // 01   11   1  -> r1=0, r0=1, c1=1, c0=1
    // 10   00   1  -> r1=1, r0=0, c1=0, c0=0
    // 10   01   1  -> r1=1, r0=0, c1=0, c0=1

    // Let's derive SOP from these minterms:

    // Group1: r1=1, c1=0
    // Covers: (11,00), (11,01), (10,00), (10,01)
    // Expression: r1 & ~c1

    // The remaining minterm:
    // (01,11) -> r1=0, r0=1, c1=1, c0=1
    // Expression: ~r1 & r0 & c1 & c0

    // Final function:
    // f = (r1 & ~c1) | (~r1 & r0 & c1 & c0)

    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & c0);

endmodule