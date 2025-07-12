module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};
    wire [4:0] eq_matrix [4:0]; // 5x5 matrix of pairwise equal bits

    genvar i, j;

    // Generate upper triangle including diagonal
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_row
            for (j = i; j < 5; j = j + 1) begin : gen_col
                assign eq_matrix[i][j] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

    // Fill lower triangle by symmetry (eq_matrix[j][i] = eq_matrix[i][j])
    generate
        for (i = 1; i < 5; i = i + 1) begin : gen_lower_row
            for (j = 0; j < i; j = j + 1) begin : gen_lower_col
                assign eq_matrix[i][j] = eq_matrix[j][i];
            end
        end
    endgenerate

    // Flatten the 5x5 matrix row-wise into out[24:0]
    assign out = {
        eq_matrix[0][0], eq_matrix[0][1], eq_matrix[0][2], eq_matrix[0][3], eq_matrix[0][4],
        eq_matrix[1][0], eq_matrix[1][1], eq_matrix[1][2], eq_matrix[1][3], eq_matrix[1][4],
        eq_matrix[2][0], eq_matrix[2][1], eq_matrix[2][2], eq_matrix[2][3], eq_matrix[2][4],
        eq_matrix[3][0], eq_matrix[3][1], eq_matrix[3][2], eq_matrix[3][3], eq_matrix[3][4],
        eq_matrix[4][0], eq_matrix[4][1], eq_matrix[4][2], eq_matrix[4][3], eq_matrix[4][4]
    };

endmodule