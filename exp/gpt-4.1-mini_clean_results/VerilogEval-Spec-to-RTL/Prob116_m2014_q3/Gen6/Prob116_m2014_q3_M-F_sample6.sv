module TopModule(
    input [3:0] x,
    output f
);
    // Correct mapping based on 0-based indexing:
    // Rows: x[3], x[2]
    // Columns: x[1], x[0]
    wire r1 = x[3];
    wire r0 = x[2];
    wire c1 = x[1];
    wire c0 = x[0];

    // Karnaugh map (rows=r1r0, cols=c1c0)
    // r1r0\c1c0 | 00 | 01 | 11 | 10
    //    00     | d  | 0  | d  | d
    //    01     | 0  | d  | 1  | 0
    //    11     | 1  | 1  | d  | d
    //    10     | 1  | 1  | 0  | d

    // Let's list the minterms where f=1:
    // Row 11 (r1=1, r0=1):
    //   Col 00 (c1=0,c0=0): f=1 → r1 r0 !c1 !c0
    //   Col 01 (c1=0,c0=1): f=1 → r1 r0 !c1 c0

    // Row 10 (r1=1, r0=0):
    //   Col 00 (c1=0,c0=0): f=1 → r1 !r0 !c1 !c0
    //   Col 01 (c1=0,c0=1): f=1 → r1 !r0 !c1 c0

    // Row 01 (r1=0, r0=1):
    //   Col 11 (c1=1,c0=1): f=1 → !r1 r0 c1 c0

    // Other ones are don't-care or zero.

    // Group the minterms for simplification:

    // Group 1: all minterms with r1=1 and c1=0
    // That covers (r1=1, c1=0), regardless of r0 and c0 where minterms exist.
    // The four minterms for r1=1 and c1=0 are:
    // (r0,c0) = (1,0), (1,1), (0,0), (0,1)
    // So group1 = r1 & ~c1

    // Group 2: isolated minterm at (r1=0, r0=1, c1=1, c0=1)
    // So group2 = ~r1 & r0 & c1 & c0

    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & c0);

endmodule