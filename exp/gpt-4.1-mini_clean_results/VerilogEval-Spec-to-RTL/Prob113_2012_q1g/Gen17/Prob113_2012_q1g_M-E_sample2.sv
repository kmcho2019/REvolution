module TopModule(
    input  [3:0] x,
    output       f
);

    // Define a 16-bit constant representing the function f for each input combination
    // Indexing: x[3:0] (MSB to LSB as binary number)
    // Map based on given Karnaugh table rows and columns:
    // The Karnaugh map indexes correspond to:
    // x3 x2 x1 x0 as bits for indexing directly:
    // For example:
    // x=0000 (0): f=1
    // x=0001 (1): f=0
    // x=0010 (2): f=1
    // x=0011 (3): f=0
    // etc., mapping according to the Karnaugh map
    //
    // To fill the vector, we map all 16 combinations in binary order:
    //
    // Input: x3 x2 x1 x0 | f (from K-map)
    // 0000 = 0 0 0 0 : 1 (row 00 col 00)
    // 0001 = 0 0 0 1 : 0 (row 00 col 01)
    // 0010 = 0 0 1 0 : 1 (row 10 col 00) -> careful: verify row/col mapping
    //
    // The Karnaugh map in the problem is arranged as:
    // Rows = x[2]x[3] (note order!) and Columns = x[0]x[1]
    //
    // But typical indexing is x3 x2 x1 x0. The problem's table labels rows as x2 x3, columns as x0 x1.
    //
    // We must ensure correct mapping:
    //
    // Let's reconstruct the vector index order: index = {x3, x2, x1, x0}
    //
    // The Karnaugh map cells correspond to:
    // f(x3,x2,x1,x0) = given in rows (x2 x3) and columns (x0 x1)
    //
    // The Karnaugh map uses x2 x3 for rows, so row number = 2*x2 + x3
    // columns x0 x1: col number = 2*x0 + x1
    //
    // The indexing in code is {x3,x2,x1,x0} = 8*x3 + 4*x2 + 2*x1 + x0
    //
    // So to translate Karnaugh map position to vector index, we must reorder bits:
    // vector_index = x3*8 + x2*4 + x1*2 + x0
    //
    // But Karnaugh map rows are x2 x3, so row = 2*x2 + x3
    // columns are x0 x1 = 2*x0 + x1
    //
    // The given f at (row,col) corresponds to f for input:
    // x3 = row[1], x2 = row[0], x1 = col[1], x0 = col[0]
    //
    // We must create a function that maps input {x3,x2,x1,x0} to f by:
    // row = {x2,x3}
    // col = {x0,x1}
    //
    // So for input:
    // index = 8*x3 + 4*x2 + 2*x1 + x0
    // Karnaugh map coordinate:
    // row = 2*x2 + x3
    // col = 2*x0 + x1
    //
    // Final f = K[row][col]
    //
    // For each index (0 to 15), we compute row and col, then get f.
    //
    // Construct the vector by iterating index from 0 to 15 and computing:
    // row = 2*x2 + x3 = 2*((index>>2)&1) + ((index>>3)&1)
    // col = 2*x0 + x1 = 2*(index&1) + ((index>>1)&1)
    //
    // Assign f according to Karnaugh map table.
    //
    // Karnaugh map table:
    // rows: 00, 01, 11, 10 (x2 x3)
    // cols: 00, 01, 11, 10 (x0 x1)
    //
    // Rows (x2 x3): 0->00,1->01,2->11,3->10
    // Columns (x0 x1): 0->00,1->01,2->11,3->10
    //
    // Given values:
    // row 00 col 00 -> 1
    // row 00 col 01 -> 0
    // row 00 col 11 -> 0
    // row 00 col 10 -> 1
    // row 01 col 00 -> 0
    // row 01 col 01 -> 0
    // row 01 col 11 -> 0
    // row 01 col 10 -> 0
    // row 11 col 00 -> 1
    // row 11 col 01 -> 1
    // row 11 col 11 -> 1
    // row 11 col 10 -> 0
    // row 10 col 00 -> 1
    // row 10 col 01 -> 1
    // row 10 col 11 -> 0
    // row 10 col 10 -> 1
    //
    // Map these to vector bits 0 to 15:
    // bit i = f for input i, where input = {x3,x2,x1,x0} = i
    //
    // Now code will do this hardcoded as a constant for clarity.

    localparam [15:0] LUT = 16'b
        // bit15 down to bit0, indexed by {x3,x2,x1,x0}
        // We write bit0 first for clarity (index 0)
        // Let's assign bits from 15 downto 0:
        // bit  0 = input 0000 = x3=0 x2=0 x1=0 x0=0
        // Compute row, col for i=0
        // row = 2*x2+x3 = 0+0=0 (row 00)
        // col = 2*x0+x1 = 0+0=0 (col 00)
        // f=1
        // ...
        // To avoid confusion, list out all 16 bits in order [bit0 ... bit15]:
        // i: x3 x2 x1 x0 : row col : f

        // i= 0: 0 0 0 0 : row=0 (00) col=0 (00) f=1
        1'b1, // bit 0

        // i= 1: 0 0 0 1 : row=0 (00) col=2*1+0=2 (11?) Wait col bits are x0 x1, so col = 2*x0 + x1
        // For i=1 (0001): x3=0, x2=0, x1=0, x0=1
        // row = 0
        // col = 2*1 + 0 = 2 (col 11)
        // f=0
        1'b0, // bit 1

        // i= 2: 0 0 1 0: x3=0,x2=0,x1=1,x0=0
        // row=0 col=2*0+1=1 (col 01)
        // f=0
        1'b0, // bit 2

        // i= 3: 0 0 1 1: x3=0,x2=0,x1=1,x0=1
        // row=0 col=2*1+1=3 (col 10)
        // f=1
        1'b1, // bit 3

        // i= 4: 0 1 0 0: x3=0,x2=1,x1=0,x0=0
        // row=2*x2+x3=2*1+0=2 (row 11)
        // col=2*x0+x1=0+0=0 (col 00)
        // f=1
        1'b1, // bit 4

        // i= 5: 0 1 0 1: x3=0,x2=1,x1=0,x0=1
        // row=2 (11) col=2*1+0=2 (col 11)
        // f=1
        1'b1, // bit 5

        // i= 6: 0 1 1 0: x3=0,x2=1,x1=1,x0=0
        // row=2 col=2*0+1=1 (col 01)
        // f=1
        1'b1, // bit 6

        // i= 7: 0 1 1 1: x3=0,x2=1,x1=1,x0=1
        // row=2 col=2*1+1=3 (col 10)
        // f=0
        1'b0, // bit 7

        // i= 8: 1 0 0 0: x3=1,x2=0,x1=0,x0=0
        // row=2*x2+x3=0+1=1 (row 01)
        // col=2*0+0=0 (col 00)
        // f=0
        1'b0, // bit 8

        // i= 9: 1 0 0 1: x3=1,x2=0,x1=0,x0=1
        // row=1 col=2*1+0=2 (col 11)
        // f=0
        1'b0, // bit 9

        // i=10:1 0 1 0: x3=1,x2=0,x1=1,x0=0
        // row=1 col=2*0+1=1 (col 01)
        // f=0
        1'b0, // bit 10

        // i=11:1 0 1 1: x3=1,x2=0,x1=1,x0=1
        // row=1 col=3 (col 10)
        // f=0
        1'b0, // bit 11

        // i=12:1 1 0 0: x3=1,x2=1,x1=0,x0=0
        // row=2*1+1=3 (row 10)
        // col=0 (col 00)
        // f=1
        1'b1, // bit 12

        // i=13:1 1 0 1: x3=1,x2=1,x1=0,x0=1
        // row=3 col=2*1+0=2 (col 11)
        // f=1
        1'b1, // bit 13

        // i=14:1 1 1 0: x3=1,x2=1,x1=1,x0=0
        // row=3 col=2*0+1=1 (col 01)
        // f=0
        1'b0, // bit 14

        // i=15:1 1 1 1: x3=1,x2=1,x1=1,x0=1
        // row=3 col=3 (col 10)
        // f=1
        1'b1  // bit 15
    ;

    // Output assignment using indexed bit from LUT
    assign f = LUT[x];

endmodule