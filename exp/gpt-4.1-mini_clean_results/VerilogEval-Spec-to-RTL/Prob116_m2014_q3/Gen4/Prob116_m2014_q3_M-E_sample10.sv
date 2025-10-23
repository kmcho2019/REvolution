module TopModule (
    input  [3:0] x,   // x[3], x[2], x[1], x[0] but note x[4] is missing from 4 bits, 
                       // assuming user meant x[3:0] as 4 bits: x[3],x[2],x[1],x[0]
                       // but problem states x is 4 bits, so bits are x[3], x[2], x[1], x[0]
                       // K-map references x[3]x[4] as row bits; since only 4 bits, we must assign x[4] to x[0].
                       // To match problem statement and K-map, we must clarify the interface.
                       // However, problem states input x is 4 bits; rows = x[3], x[4] means bit 4 which doesn't exist.
                       // So assuming x[3:0] corresponds to {x[3], x[2], x[1], x[0]}, 
                       // and the K-map label x[1]x[2] means bits x[1] and x[2], 
                       // and x[3]x[4] is possibly x[3] and x[0] based on indexing
                       // For clarity and correctness, I will define row bits as x[3], x[0] and column bits as x[1], x[2].
                       // This matches common practice to reuse bits since only 4 bits present.

                       // Thus row = {x[3], x[0]}, column = {x[1], x[2]}

    output      f
);

    // Decode rows: 2 bits => 4 lines
    wire [3:0] row_decode;
    assign row_decode = 4'b0001 << ({x[3], x[0]});

    // Decode columns: 2 bits => 4 lines
    wire [3:0] col_decode;
    assign col_decode = 4'b0001 << ({x[1], x[2]});

    // Karnaugh map cells with values (1 = function true, d = don't care (0 here), 0 = false):
    // rows (x[3]x[0]) down, columns (x[1]x[2]) across
    //
    //           00   01   11   10  (columns)
    // 00 (0) |  d |  0 |  d |  d |
    // 01 (1) |  0 |  d |  1 |  0 |
    // 11 (3) |  1 |  1 |  d |  d |
    // 10 (2) |  1 |  1 |  0 |  d |
    //
    // Index rows from 0 to 3 as {x[3], x[0]}:
    // 0: 00, 1: 01, 2:10, 3:11
    // Similarly for columns {x[1], x[2]}.

    // Build minterms for each '1' cell by ANDing row and column decode bits:

    wire f_cell_1_11 = row_decode[3] & col_decode[0]; // row=11, col=00 => f=1
    wire f_cell_1_12 = row_decode[3] & col_decode[1]; // row=11, col=01 => f=1
    wire f_cell_1_21 = row_decode[2] & col_decode[0]; // row=10, col=00 => f=1
    wire f_cell_1_22 = row_decode[2] & col_decode[1]; // row=10, col=01 => f=1
    wire f_cell_1_33 = row_decode[1] & col_decode[2]; // row=01, col=11 => f=1
    wire f_cell_1_31 = row_decode[3] & col_decode[1]; // already included as f_cell_1_12, duplicate, omit
    // no need to repeat duplicates

    assign f = f_cell_1_11 |
               f_cell_1_12 |
               f_cell_1_21 |
               f_cell_1_22 |
               f_cell_1_33 ;

endmodule