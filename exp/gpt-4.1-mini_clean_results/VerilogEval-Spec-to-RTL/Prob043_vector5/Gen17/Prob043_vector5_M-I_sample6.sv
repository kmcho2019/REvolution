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
    // Create a 5x5 matrix of wires for equality results
    wire eq_matrix [4:0][4:0];

    // Generate equality for lower triangle including diagonal (i >= j)
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j <= i; j = j + 1) begin : gen_j
                assign eq_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // For upper triangle (i < j), mirror the lower triangle
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i_mirror
            for (j = i + 1; j < 5; j = j + 1) begin : gen_j_mirror
                assign eq_matrix[i][j] = eq_matrix[j][i];
            end
        end
    endgenerate

    // Flatten eq_matrix into out vector following the specified order:
    // out[24] = eq_matrix[0][0] (a vs a)
    // out[23] = eq_matrix[0][1] (a vs b)
    // ...
    // out[0]  = eq_matrix[4][4] (e vs e)
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_out_i
            for (j = 0; j < 5; j = j + 1) begin : gen_out_j
                localparam int idx = 24 - (5*i + j);
                assign out[idx] = eq_matrix[i][j];
            end
        end
    endgenerate

endmodule