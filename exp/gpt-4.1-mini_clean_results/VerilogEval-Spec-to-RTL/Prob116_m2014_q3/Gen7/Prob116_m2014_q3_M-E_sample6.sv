module TopModule(
    input  [3:0] x,
    output      f
);

    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];

    // Define each row's 4 bits according to Karnaugh map columns (00, 01, 11, 10)
    // Karnaugh map reminder:
    // row\col  00   01   11   10
    // 00       d    0    d    d
    // 01       0    d    1    0
    // 11       1    1    d    d
    // 10       1    1    0    d

    // Assign 0 to don't-care cells for simplicity:
    localparam [3:0] ROW_00 = 4'b0_0_0_0; // 00 row: d=0, 0=0, d=0, d=0 => 4'b0000
    localparam [3:0] ROW_01 = 4'b0_?_1_0; // 01 row: col 00=0, 01=d=0, 11=1, 10=0
    localparam [3:0] ROW_11 = 4'b1_1_0_0; // 11 row: col 00=1, 01=1, 11=d=0, 10=d=0
    localparam [3:0] ROW_10 = 4'b1_1_0_0; // 10 row: col 00=1, 01=1, 11=0, 10=d=0

    // Write ROW_01 carefully assigning don't-care at 01 col to 0:
    // col 00 = 0
    // col 01 = d (assign 0)
    // col 11 = 1
    // col 10 = 0
    // bit order = col00 col01 col11 col10 = [3] 00, [2] 01, [1] 11, [0] 10
    // But localparam needs consistent bit order, define col00 as MSB bit 3 and col10 as LSB bit 0
    // So bits: bit3=col00, bit2=col01, bit1=col11, bit0=col10

    // So:
    localparam [3:0] ROW00 = 4'b0000; // d=0 for all
    localparam [3:0] ROW01 = 4'b0010; // 0 (col00), 0 (col01), 1 (col11), 0 (col10)
    localparam [3:0] ROW11 = 4'b1100; // 1,1,0,0
    localparam [3:0] ROW10 = 4'b1100; // 1,1,0,0

    // Select the row vector using row:
    wire [3:0] row_vector;
    assign row_vector = (row == 2'b00) ? ROW00 :
                        (row == 2'b01) ? ROW01 :
                        (row == 2'b11) ? ROW11 :
                                         ROW10; // default row=10

    // Now select bit according to col: col00=bit3 ... col10=bit0
    // So mapping col[1:0] to bit index: 00->3, 01->2, 11->1, 10->0
    wire [1:0] col_idx;
    assign col_idx = (col == 2'b00) ? 2'd3 :
                     (col == 2'b01) ? 2'd2 :
                     (col == 2'b11) ? 2'd1 :
                                      2'd0; // col==10

    assign f = row_vector[col_idx];

endmodule