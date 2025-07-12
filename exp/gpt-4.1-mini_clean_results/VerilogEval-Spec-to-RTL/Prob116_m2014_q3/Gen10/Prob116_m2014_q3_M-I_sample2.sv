module TopModule(
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    // Assign named bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Form index as per Karnaugh map: rows = x3 x4, columns = x1 x2
    wire [3:0] idx = {x3, x4, x1, x2};

    // Karnaugh map values (row: x3 x4, col: x1 x2)
    //             00  01  11  10  (x1x2)
    //         00 | d | 0 | d | d |  (x3x4=00)
    //         01 | 0 | d | 1 | 0 |  (x3x4=01)
    //         11 | 1 | 1 | d | d |  (x3x4=11)
    //         10 | 1 | 1 | 0 | d |  (x3x4=10)
    //
    // Assign don't-cares (d) = 0 for deterministic output
    //
    // Enumerate f values for all indices (0 to 15):
    // idx = row*4 + col = (x3x4)*4 + (x1x2)
    // x3x4: 00=0, 01=1, 10=2, 11=3 (in decimal)
    //
    // idx: decimal (x3x4, x1x2), f
    // 0  (00,00) = 0, d->0
    // 1  (00,01) = 1, 0
    // 2  (00,11) = 3, d->0
    // 3  (00,10) = 2, d->0
    //
    // 4  (01,00) = 4, 0
    // 5  (01,01) = 5, d->0
    // 6  (01,11) = 7, 1
    // 7  (01,10) = 6, 0
    //
    // 8  (10,00) = 8, 1
    // 9  (10,01) = 9, 1
    // 10 (10,11) = 11,d->0
    // 11 (10,10) = 10,0
    //
    // 12 (11,00) = 12,1
    // 13 (11,01) = 13,1
    // 14 (11,11) = 15,d->0
    // 15 (11,10) = 14,d->0

    localparam [15:0] f_lut = 16'b0000100110011110;

    assign f = f_lut[idx];

endmodule