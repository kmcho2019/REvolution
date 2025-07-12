module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexing
    wire [4:0] in_vec = {a,b,c,d,e};
    wire [4:0] row, col;
    wire [4:0] out_mat [4:0]; // 5x5 matrix

    // Compute unique pairs once (upper triangle and diagonal)
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : ROW_LOOP
            for (j = 0; j < 5; j = j + 1) begin : COL_LOOP
                if (i <= j) begin
                    // Compute equality once for upper triangle and diagonal
                    assign out_mat[i][j] = ~(in_vec[i] ^ in_vec[j]);
                end else begin
                    // Assign symmetric value for lower triangle
                    assign out_mat[i][j] = out_mat[j][i];
                end
            end
        end
    endgenerate

    // Flatten the 5x5 matrix into a 25-bit vector in the specified order:
    // out[24] = out_mat[0][0], out[23] = out_mat[0][1], ..., out[20] = out_mat[0][4]
    // out[19] = out_mat[1][0], ..., out[15] = out_mat[1][4]
    // ...
    // out[4] = out_mat[4][0], ..., out[0] = out_mat[4][4]
    assign out = {
        out_mat[0][0], out_mat[0][1], out_mat[0][2], out_mat[0][3], out_mat[0][4],
        out_mat[1][0], out_mat[1][1], out_mat[1][2], out_mat[1][3], out_mat[1][4],
        out_mat[2][0], out_mat[2][1], out_mat[2][2], out_mat[2][3], out_mat[2][4],
        out_mat[3][0], out_mat[3][1], out_mat[3][2], out_mat[3][3], out_mat[3][4],
        out_mat[4][0], out_mat[4][1], out_mat[4][2], out_mat[4][3], out_mat[4][4]
    };

endmodule