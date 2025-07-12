module TopModule(
    input [3:0] x,
    output f
);
    // First decode the row (x[3:2])
    wire [3:0] row_select;
    assign row_select[0] = ~x[3] & ~x[2];  // 00
    assign row_select[1] = ~x[3] &  x[2];  // 01
    assign row_select[2] =  x[3] &  x[2];  // 11
    assign row_select[3] =  x[3] & ~x[2];  // 10

    // Then decode the column (x[1:0])
    wire [3:0] col_select;
    assign col_select[0] = ~x[1] & ~x[0];  // 00
    assign col_select[1] = ~x[1] &  x[0];  // 01
    assign col_select[2] =  x[1] &  x[0];  // 11
    assign col_select[3] =  x[1] & ~x[0];  // 10

    // Implement the K-map as a ROM
    wire [3:0] rom_output;
    assign rom_output[0] = 1'b0;  // Row 00: d,0,d,d -> choose 0 for first column
    assign rom_output[1] = (~x[0]) | (x[0] & ~x[1]);  // Row 01: optimized to cover 0,d,1,0
    assign rom_output[2] = 1'b1;  // Row 11: 1,1,d,d -> choose 1 for first two columns
    assign rom_output[3] = ~x[0];  // Row 10: 1,1,0,d -> covers all needed cases

    // Final output selection
    assign f = (row_select[0] & rom_output[0]) |
               (row_select[1] & rom_output[1]) |
               (row_select[2] & rom_output[2]) |
               (row_select[3] & rom_output[3]);
endmodule