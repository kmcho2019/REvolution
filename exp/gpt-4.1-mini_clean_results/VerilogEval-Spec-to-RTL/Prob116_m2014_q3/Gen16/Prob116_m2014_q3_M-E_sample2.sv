module TopModule (
    input  [3:0] x,  // x[3:0] corresponds to x4..x1 as given
    output       f
);

    // Define ROM contents for all 16 inputs.
    // Indexing by x[3:0] directly maps to the problem's Gray-coded Karnaugh map cells:
    // The Karnaugh map cells arranged in order of x[3:0]:
    // x[3]x[2] (row), x[1]x[0] (col)
    // Using the problem map (rows and cols Gray coded):
    // Index = {x4,x3,x2,x1} = x[3], x[2], x[1], x[0]
    //
    // Karnaugh map table (x[3],x[2]) rows and (x[1],x[0]) cols:
    //          00    01    11    10 (cols)
    // 00       d=0   0     d=0   d=0
    // 01       0     d=0   1     0
    // 11       1     1     d=0   d=0
    // 10       1     1     0     d=0
    //
    // Assign don't-cares (d) = 0 for simplicity.
    //
    // Entries indexed by x[3:0] = {x4,x3,x2,x1} as bits:
    //   row = {x4,x3}, col = {x2,x1}
    // We list all 16 entries in order:
    // address : value
    // 0: 0000 => row=00,col=00 => d=0
    // 1: 0001 => 00,01 => 0
    // 2: 0010 => 00,10 => d=0
    // 3: 0011 => 00,11 => d=0
    // 4: 0100 => 01,00 => 0
    // 5: 0101 => 01,01 => d=0
    // 6: 0110 => 01,10 => 1
    // 7: 0111 => 01,11 => 0
    // 8: 1000 => 10,00 => 1
    // 9: 1001 => 10,01 => 1
    // 10:1010 => 10,10 => 0
    // 11:1011 => 10,11 => d=0
    // 12:1100 => 11,00 => 1
    // 13:1101 => 11,01 => 1
    // 14:1110 => 11,10 => d=0
    // 15:1111 => 11,11 => d=0

    localparam [15:0] ROM_CONTENT = 16'b0000_1000_1100_1100;

    // Assign output by indexing ROM with input x
    assign f = ROM_CONTENT[x];

endmodule