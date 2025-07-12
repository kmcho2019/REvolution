module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs: inputs[4] = a down to inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // 2D wire array (5x5) for comparisons, only upper triangle computed explicitly
    wire cmp [4:0][4:0];

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                if (i <= j) begin
                    // Compute upper triangle and diagonal using XNOR (~^)
                    assign cmp[i][j] = ~(inputs[4 - i] ^ inputs[4 - j]);
                end else begin
                    // Reuse symmetric values for lower triangle to save gates
                    assign cmp[i][j] = cmp[j][i];
                end
            end
        end
    endgenerate

    // Flatten the 2D cmp matrix into the 25-bit output vector
    // out[24 - (5*i + j)] = cmp[i][j]
    assign out = {
        cmp[0][0], cmp[0][1], cmp[0][2], cmp[0][3], cmp[0][4],
        cmp[1][0], cmp[1][1], cmp[1][2], cmp[1][3], cmp[1][4],
        cmp[2][0], cmp[2][1], cmp[2][2], cmp[2][3], cmp[2][4],
        cmp[3][0], cmp[3][1], cmp[3][2], cmp[3][3], cmp[3][4],
        cmp[4][0], cmp[4][1], cmp[4][2], cmp[4][3], cmp[4][4]
    };

endmodule