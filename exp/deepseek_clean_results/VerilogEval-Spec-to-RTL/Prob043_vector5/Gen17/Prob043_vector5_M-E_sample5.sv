module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);

    // Create a 5x5 matrix of comparison results
    wire [4:0] inputs = {a, b, c, d, e};
    wire [4:0][4:0] comp_matrix;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_gen
            for (j = 0; j < 5; j = j + 1) begin : col_gen
                assign comp_matrix[i][j] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

    // Flatten the matrix in row-major order
    assign out = {
        comp_matrix[4][4], comp_matrix[4][3], comp_matrix[4][2], comp_matrix[4][1], comp_matrix[4][0],
        comp_matrix[3][4], comp_matrix[3][3], comp_matrix[3][2], comp_matrix[3][1], comp_matrix[3][0],
        comp_matrix[2][4], comp_matrix[2][3], comp_matrix[2][2], comp_matrix[2][1], comp_matrix[2][0],
        comp_matrix[1][4], comp_matrix[1][3], comp_matrix[1][2], comp_matrix[1][1], comp_matrix[1][0],
        comp_matrix[0][4], comp_matrix[0][3], comp_matrix[0][2], comp_matrix[0][1], comp_matrix[0][0]
    };

endmodule