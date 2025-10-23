module TopModule(
    input [3:0] x,
    output f
);
    // Map input bits to Karnaugh map bits:
    // Row bits: x[3], x[4] → x[3], x[0]
    // Column bits: x[1], x[2]

    wire r1 = x[3]; // row MSB
    wire r0 = x[0]; // row LSB (x[4] mapped to x[0])
    wire c1 = x[1]; // column MSB
    wire c0 = x[2]; // column LSB

    // Karnaugh map (row, col):
    //         00   01   11   10
    // 00 |  d |  0 |  d |  d |
    // 01 |  0 |  d |  1 |  0 |
    // 11 |  1 |  1 |  d |  d |
    // 10 |  1 |  1 |  0 |  d |

    // Identify minterms for f=1 (row bits r1r0, col bits c1c0):
    // 1) row=11 (r1=1, r0=1), col=00 (c1=0, c0=0) => r1 & r0 & ~c1 & ~c0
    // 2) row=11 (1,1), col=01 (0,1) => r1 & r0 & ~c1 & c0
    // 3) row=10 (1,0), col=00 (0,0) => r1 & ~r0 & ~c1 & ~c0
    // 4) row=10 (1,0), col=01 (0,1) => r1 & ~r0 & ~c1 & c0
    // 5) row=01 (0,1), col=11 (1,1) => ~r1 & r0 & c1 & c0
    // 6) row=11 (1,1), col=01 (0,1) repeated in #2
    // 7) row=11 (1,1), col=00 (0,0) repeated in #1
    // 8) row=10 (1,0), col=01 (0,1) repeated in #4
    // 9) row=10 (1,0), col=00 (0,0) repeated in #3

    // Groupings:
    // Terms #1 and #2: r1 & r0 & ~c1 & (c0 + ~c0) => r1 & r0 & ~c1
    // Terms #3 and #4: r1 & ~r0 & ~c1 & (c0 + ~c0) => r1 & ~r0 & ~c1
    // Combine above two: r1 & ~c1

    // Term #5 isolated: ~r1 & r0 & c1 & c0

    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & c0);

endmodule