module TopModule(
    input [3:0] x,  // x[3:4] are row bits, x[1:2] are column bits
    output f
);
    // Row decoder
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] &  x[2];
    wire row11 =  x[3] &  x[2];
    wire row10 =  x[3] & ~x[2];

    // Column logic for each row
    wire row00_out = row00 & (~x[1] & x[0]);  // Only care about 01 column (0)
    wire row01_out = row01 & (
        (~x[1] & ~x[0]) |  // 00 column (0)
        ( x[1] &  x[0]) |  // 11 column (1)
        ( x[1] & ~x[0])    // 10 column (0)
    );
    wire row11_out = row11 & (x[1] | ~x[0]);  // All 1 except where both are 0
    wire row10_out = row10 & (x[1] & x[0]);    // Only 1 when both are 1

    // Combine outputs with priority (don't-cares resolved naturally)
    assign f = row00_out | row01_out | row11_out | row10_out;
endmodule