module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 per problem notation
    output      f
);

    // Map problem bits for clarity
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Gray-to-binary decoding for row (x3,x4)
    wire row_gray1 = x3;
    wire row_gray0 = x4;
    wire row_bin1  = row_gray1;
    wire row_bin0  = row_gray1 ^ row_gray0;

    // Gray-to-binary decoding for column (x1,x2)
    wire col_gray1 = x1;
    wire col_gray0 = x2;
    wire col_bin1  = col_gray1;
    wire col_bin0  = col_gray1 ^ col_gray0;

    // Compute Karnaugh map output by sum-of-products on decoded indices:
    // From Example 2's '1' cells remapped to binary indices:
    // The original problem '1's:
    // (row_gray, col_gray) = 
    // (11,00), (11,01), (10,00), (10,01), (01,11)

    // Convert these Gray row and column codes to binary:
    // Gray to binary:
    // row_gray = {x3,x4}, binary = {row_bin1,row_bin0}
    // col_gray = {x1,x2}, binary = {col_bin1,col_bin0}
    //
    // Mapping each:
    // (11,00): row_gray=11 -> row_bin=10; col_gray=00 -> col_bin=00
    // (11,01): row_gray=11 -> row_bin=10; col_gray=01 -> col_bin=01
    // (10,00): row_gray=10 -> row_bin=11; col_gray=00 -> col_bin=00
    // (10,01): row_gray=10 -> row_bin=11; col_gray=01 -> col_bin=01
    // (01,11): row_gray=01 -> row_bin=01; col_gray=11 -> col_bin=10
    //
    // So the '1' output cells (row_bin,col_bin):
    // (10,00), (10,01), (11,00), (11,01), (01,10)

    wire r1 = row_bin1;
    wire r0 = row_bin0;
    wire c1 = col_bin1;
    wire c0 = col_bin0;

    // Express these minterms:
    // (10,00) = r1=1, r0=0, c1=0, c0=0
    // (10,01) = r1=1, r0=0, c1=0, c0=1
    // (11,00) = r1=1, r0=1, c1=0, c0=0
    // (11,01) = r1=1, r0=1, c1=0, c0=1
    // (01,10) = r1=0, r0=1, c1=1, c0=0

    // Factor common terms:
    // First four minterms share r1=1 and c1=0:
    // f = r1 & ~c1 & (~r0 & ~c0 | ~r0 & c0 | r0 & ~c0 | r0 & c0)
    // The expression in parentheses covers all combinations of r0 and c0 -> it's always true
    // So, for these four minterms: f_part1 = r1 & ~c1
    //
    // The last minterm: r1=0, r0=1, c1=1, c0=0
    // f_part2 = ~r1 & r0 & c1 & ~c0
    //
    // Final function:
    // f = (r1 & ~c1) | (~r1 & r0 & c1 & ~c0)

    assign f = (r1 & ~c1) | (~r1 & r0 & c1 & ~c0);

endmodule