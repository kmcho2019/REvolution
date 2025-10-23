module TopModule(
    input [3:0] x,
    output f
);
    // Row decoders (x[3:2])
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] &  x[2];
    wire row11 =  x[3] &  x[2];
    wire row10 =  x[3] & ~x[2];

    // Column decoders (x[1:0])
    wire col00 = ~x[1] & ~x[0];
    wire col01 = ~x[1] &  x[0];
    wire col11 =  x[1] &  x[0];
    wire col10 =  x[1] & ~x[0];

    // Minterms for each '1' in K-map
    wire m0 = row00 & col00;  // 00,00
    wire m1 = row00 & col10;  // 00,10
    wire m2 = row11 & col00;  // 11,00
    wire m3 = row11 & col01;  // 11,01
    wire m4 = row11 & col11;  // 11,11
    wire m5 = row10 & col00;  // 10,00
    wire m6 = row10 & col01;  // 10,01
    wire m7 = row10 & col10;  // 10,10

    // Combine all minterms
    assign f = m0 | m1 | m2 | m3 | m4 | m5 | m6 | m7;
endmodule