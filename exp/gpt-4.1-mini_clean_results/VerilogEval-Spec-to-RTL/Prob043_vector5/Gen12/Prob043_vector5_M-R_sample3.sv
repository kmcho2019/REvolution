module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexed access: inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // 2D wire array to hold pairwise comparisons: comp[i][j] = inputs[i] ~^ inputs[j]
    wire comp [0:4][0:4];

    genvar i, j;
    generate
        // Compute all pairwise comparisons in the 2D array
        for (i = 0; i < 5; i = i + 1) begin : gen_comp_i
            for (j = 0; j < 5; j = j + 1) begin : gen_comp_j
                assign comp[i][j] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

    // Flatten the 2D comp array into the 25-bit output vector with correct bit ordering
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_out_i
            for (j = 0; j < 5; j = j + 1) begin : gen_out_j
                // out[24 - (5*i + j)] = comp[i][j]
                assign out[24 - (5*i + j)] = comp[i][j];
            end
        end
    endgenerate

endmodule