module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Assign input bits for clarity and to match problem notation
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Gray-to-binary conversion for row bits (x3,x4)
    // binary_row[1] = x3 (MSB)
    // binary_row[0] = x3 ^ x4 (LSB)
    wire row_msb = x3;
    wire row_lsb = x3 ^ x4;

    // Gray-to-binary conversion for column bits (x1,x2)
    // binary_col[1] = x1 (MSB)
    // binary_col[0] = x1 ^ x2 (LSB)
    wire col_msb = x1;
    wire col_lsb = x1 ^ x2;

    // From Example 1 minterms mapped after decoding:
    // Ones at K-map positions (row,col) after Gray->binary decoding:
    // (11,00), (11,01), (10,00), (10,01), (01,11)

    // Translated to binary indices:
    // row=1,1; col=0,0 => row_msb=1, row_lsb=1, col_msb=0, col_lsb=0
    // row=1,1; col=0,1 => row_msb=1, row_lsb=1, col_msb=0, col_lsb=1
    // row=1,0; col=0,0 => row_msb=1, row_lsb=0, col_msb=0, col_lsb=0
    // row=1,0; col=0,1 => row_msb=1, row_lsb=0, col_msb=0, col_lsb=1
    // row=0,1; col=1,1 => row_msb=0, row_lsb=1, col_msb=1, col_lsb=1

    // Factoring terms:

    // Group1: row_msb=1 and col_msb=0:
    // Covers (1,1,0,0), (1,1,0,1), (1,0,0,0), (1,0,0,1)
    // Notice row_lsb varies (0 or 1), col_lsb varies (0 or 1) but col_msb=0 fixed
    // So term: row_msb & ~col_msb

    // Group2: row=01 and col=11 (only one minterm)
    // row_msb=0, row_lsb=1, col_msb=1, col_lsb=1
    // So term: ~row_msb & row_lsb & col_msb & col_lsb

    // Final simplified logic:
    // f = (row_msb & ~col_msb) | (~row_msb & row_lsb & col_msb & col_lsb)

    assign f = (row_msb & ~col_msb) | (~row_msb & row_lsb & col_msb & col_lsb);

endmodule