module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;

    // Temporary array to hold the bits before flattening
    wire [4:0] equality_matrix [4:0];

    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                assign equality_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Flatten the 5x5 matrix into a 25-bit vector
    // out[24] = equality_matrix[0][0], out[23] = equality_matrix[0][1], ..., out[0] = equality_matrix[4][4]
    generate
        for (i = 0; i < 5; i = i + 1) begin : flatten_row
            for (j = 0; j < 5; j = j + 1) begin : flatten_col
                assign out[24 - (i*5 + j)] = equality_matrix[i][j];
            end
        end
    endgenerate

endmodule