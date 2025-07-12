module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    wire cmp [4:0][4:0];

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : ROWS
            for (j = 0; j < 5; j = j + 1) begin : COLS
                assign cmp[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Flatten cmp[0][0]..cmp[4][4] into out[24:0], where out[24] = cmp[0][0], out[23] = cmp[0][1], ...
    assign out = {
        cmp[0][0], cmp[0][1], cmp[0][2], cmp[0][3], cmp[0][4],
        cmp[1][0], cmp[1][1], cmp[1][2], cmp[1][3], cmp[1][4],
        cmp[2][0], cmp[2][1], cmp[2][2], cmp[2][3], cmp[2][4],
        cmp[3][0], cmp[3][1], cmp[3][2], cmp[3][3], cmp[3][4],
        cmp[4][0], cmp[4][1], cmp[4][2], cmp[4][3], cmp[4][4]
    };

endmodule