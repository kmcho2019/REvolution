module TopModule(
    input [3:0] x,
    output f
);
    // Decode x[3:2] into one-hot (row select)
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] & x[2];
    wire row11 = x[3] & x[2];
    wire row10 = x[3] & ~x[2];

    // Decode x[1:0] into one-hot (column select)
    wire col00 = ~x[1] & ~x[0];
    wire col01 = ~x[1] & x[0];
    wire col11 = x[1] & x[0];
    wire col10 = x[1] & ~x[0];

    // Create the K-map grid (only where f=1)
    wire cell00_00 = row00 & col00;  // 1
    wire cell00_10 = row00 & col10;  // 1
    wire cell11_00 = row11 & col00;  // 1
    wire cell11_01 = row11 & col01;  // 1
    wire cell11_11 = row11 & col11;  // 1
    wire cell10_00 = row10 & col00;  // 1
    wire cell10_01 = row10 & col01;  // 1
    wire cell10_10 = row10 & col10;  // 1

    // OR together all active cells
    assign f = cell00_00 | cell00_10 |
               cell11_00 | cell11_01 | cell11_11 |
               cell10_00 | cell10_01 | cell10_10;
endmodule