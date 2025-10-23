module TopModule(
    input [3:0] x,
    output f
);
    // Row decoder (x[3:2])
    wire [3:0] row_dec;
    assign row_dec[0] = ~x[3] & ~x[2];  // 00
    assign row_dec[1] = ~x[3] &  x[2];  // 01
    assign row_dec[2] =  x[3] &  x[2];  // 11
    assign row_dec[3] =  x[3] & ~x[2];  // 10

    // Column decoder (x[1:0])
    wire [3:0] col_dec;
    assign col_dec[0] = ~x[1] & ~x[0];  // 00
    assign col_dec[1] = ~x[1] &  x[0];  // 01
    assign col_dec[2] =  x[1] &  x[0];  // 11
    assign col_dec[3] =  x[1] & ~x[0];  // 10

    // Direct K-map implementation
    assign f = (row_dec[0] & col_dec[0]) |  // 00,00
               (row_dec[0] & col_dec[3]) |  // 00,10
               (row_dec[2] & col_dec[0]) |  // 11,00
               (row_dec[2] & col_dec[1]) |  // 11,01
               (row_dec[2] & col_dec[2]) |  // 11,11
               (row_dec[3] & col_dec[0]) |  // 10,00
               (row_dec[3] & col_dec[1]) |  // 10,01
               (row_dec[3] & col_dec[3]);   // 10,10
endmodule