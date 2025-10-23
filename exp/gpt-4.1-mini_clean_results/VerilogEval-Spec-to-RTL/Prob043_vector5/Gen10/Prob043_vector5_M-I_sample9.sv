module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare a 5x5 array to store pairwise equalities
    wire equality_matrix [4:0][4:0];

    genvar i, j;
    generate
        // Compute only upper triangle including diagonal
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = i; j < 5; j = j + 1) begin : col_loop
                assign equality_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end
        // Mirror upper triangle to lower triangle for symmetry
        for (i = 1; i < 5; i = i + 1) begin : row_mirror_loop
            for (j = 0; j < i; j = j + 1) begin : col_mirror_loop
                assign equality_matrix[i][j] = equality_matrix[j][i];
            end
        end
    endgenerate

    // Flatten the 2D matrix into out[24:0] with the specified ordering:
    // out[24] = equality_matrix[0][0] (a vs a)
    // out[23] = equality_matrix[0][1] (a vs b)
    // ...
    // out[0] = equality_matrix[4][4] (e vs e)

    generate
        for (i = 0; i < 5; i = i + 1) begin : flatten_row
            for (j = 0; j < 5; j = j + 1) begin : flatten_col
                // Calculate output index: index = 24 - (i*5 + j)
                localparam integer out_idx = 24 - (i*5 + j);
                assign out[out_idx] = equality_matrix[i][j];
            end
        end
    endgenerate

endmodule