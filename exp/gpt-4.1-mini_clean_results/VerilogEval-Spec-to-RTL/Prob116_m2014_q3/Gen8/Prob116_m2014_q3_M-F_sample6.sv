module TopModule(
    input  [3:0] x,
    output      f
);

    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];

    // Define row vectors with correct assigned don't-care values:
    // bit3 = col00, bit2 = col01, bit1 = col11, bit0 = col10

    localparam [3:0] ROW00 = 4'b1011; // d=1 at col00, 0, d=1, d=1
    localparam [3:0] ROW01 = 4'b0010; // 0, d=0, 1, 0
    localparam [3:0] ROW11 = 4'b1100; // 1,1,d=0,d=0
    localparam [3:0] ROW10 = 4'b1100; // 1,1,0,d=0

    wire [3:0] row_vector = (row == 2'b00) ? ROW00 :
                            (row == 2'b01) ? ROW01 :
                            (row == 2'b11) ? ROW11 :
                                             ROW10;

    // Map col to bit index for row_vector indexing
    wire [1:0] col_idx = (col == 2'b00) ? 2'd3 :
                         (col == 2'b01) ? 2'd2 :
                         (col == 2'b11) ? 2'd1 :
                                          2'd0;

    assign f = row_vector[col_idx];

endmodule