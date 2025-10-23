module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare a 5x5 array of wires for pairwise equality
    wire eq_matrix [4:0][4:0];

    // Compute pairwise equality with XNOR
    assign eq_matrix[0][0] = inputs[4] ~^ inputs[4]; // a vs a
    assign eq_matrix[0][1] = inputs[4] ~^ inputs[3]; // a vs b
    assign eq_matrix[0][2] = inputs[4] ~^ inputs[2]; // a vs c
    assign eq_matrix[0][3] = inputs[4] ~^ inputs[1]; // a vs d
    assign eq_matrix[0][4] = inputs[4] ~^ inputs[0]; // a vs e

    assign eq_matrix[1][0] = inputs[3] ~^ inputs[4]; // b vs a
    assign eq_matrix[1][1] = inputs[3] ~^ inputs[3]; // b vs b
    assign eq_matrix[1][2] = inputs[3] ~^ inputs[2]; // b vs c
    assign eq_matrix[1][3] = inputs[3] ~^ inputs[1]; // b vs d
    assign eq_matrix[1][4] = inputs[3] ~^ inputs[0]; // b vs e

    assign eq_matrix[2][0] = inputs[2] ~^ inputs[4]; // c vs a
    assign eq_matrix[2][1] = inputs[2] ~^ inputs[3]; // c vs b
    assign eq_matrix[2][2] = inputs[2] ~^ inputs[2]; // c vs c
    assign eq_matrix[2][3] = inputs[2] ~^ inputs[1]; // c vs d
    assign eq_matrix[2][4] = inputs[2] ~^ inputs[0]; // c vs e

    assign eq_matrix[3][0] = inputs[1] ~^ inputs[4]; // d vs a
    assign eq_matrix[3][1] = inputs[1] ~^ inputs[3]; // d vs b
    assign eq_matrix[3][2] = inputs[1] ~^ inputs[2]; // d vs c
    assign eq_matrix[3][3] = inputs[1] ~^ inputs[1]; // d vs d
    assign eq_matrix[3][4] = inputs[1] ~^ inputs[0]; // d vs e

    assign eq_matrix[4][0] = inputs[0] ~^ inputs[4]; // e vs a
    assign eq_matrix[4][1] = inputs[0] ~^ inputs[3]; // e vs b
    assign eq_matrix[4][2] = inputs[0] ~^ inputs[2]; // e vs c
    assign eq_matrix[4][3] = inputs[0] ~^ inputs[1]; // e vs d
    assign eq_matrix[4][4] = inputs[0] ~^ inputs[0]; // e vs e

    // Flatten eq_matrix into the output vector:
    // out[24 - (5*i + j)] = eq_matrix[i][j]
    // We create a loop-like assignment using a generate block with a function for indexing

    genvar i, j;
    generate
        for(i = 0; i < 5; i = i + 1) begin : gen_i
            for(j = 0; j < 5; j = j + 1) begin : gen_j
                localparam integer bit_idx = 24 - (5*i + j);
                assign out[bit_idx] = eq_matrix[i][j];
            end
        end
    endgenerate

endmodule