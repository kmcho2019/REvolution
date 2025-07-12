module TopModule (
    input  [3:0] x,
    output       f
);
    wire r0, r1, r2, r3; // Row decoding
    wire c0, c1, c2, c3; // Column decoding

    // Decode rows (x[3:2])
    assign r0 = (~x[3]) & (~x[2]); // 00
    assign r1 = (~x[3]) & ( x[2]); // 01
    assign r2 = ( x[3]) & (~x[2]); // 10
    assign r3 = ( x[3]) & ( x[2]); // 11

    // Decode columns (x[1:0])
    assign c0 = (~x[1]) & (~x[0]); // 00
    assign c1 = (~x[1]) & ( x[0]); // 01
    assign c2 = ( x[1]) & ( x[0]); // 11
    assign c3 = ( x[1]) & (~x[0]); // 10

    // From K-map analysis (using 'd' as don't-care, choose terms to cover all 1's):

    // Groups covering the '1's:
    // Group A: rows 11 and 10, columns 00 and 01 (r3 & (c0|c1)) + (r2 & (c0|c1))
    // Group B: row 11, column 01 and 11 (r3 & c1) and (r3 & c2) [but c2 is don't care, assign 0]
    // Group C: row 01, column 11 (r1 & c2)
    // Group D: row 10, column 11 = 0, ignore
    // Group E: row 01, column 11 (r1 & c2)
    // Using above, minimal expression: 
    // f = (r3 & (c0|c1)) | (r2 & (c0|c1)) | (r1 & c2)

    assign f = ((r3 | r2) & (c0 | c1)) | (r1 & c2);

endmodule