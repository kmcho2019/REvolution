module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Pack inputs into an array for indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    // 5x5 matrix to hold equality bits
    wire equality_matrix [4:0][4:0];

    genvar i, j;

    // Generate only unique comparisons (i <= j), fill symmetric entries by mirroring
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                if (i <= j) begin
                    // Compute equality with XNOR when i <= j
                    assign equality_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
                end else begin
                    // Mirror equality from the symmetric element
                    assign equality_matrix[i][j] = equality_matrix[j][i];
                end
            end
        end
    endgenerate

    // Flatten the 5x5 matrix into 25-bit output vector: out[24] = (a,a), ..., out[0] = (e,e)
    // Bit order: row-major from top-left (a,a) MSB to bottom-right (e,e) LSB
    assign out = {
        equality_matrix[0][0], equality_matrix[0][1], equality_matrix[0][2], equality_matrix[0][3], equality_matrix[0][4],
        equality_matrix[1][0], equality_matrix[1][1], equality_matrix[1][2], equality_matrix[1][3], equality_matrix[1][4],
        equality_matrix[2][0], equality_matrix[2][1], equality_matrix[2][2], equality_matrix[2][3], equality_matrix[2][4],
        equality_matrix[3][0], equality_matrix[3][1], equality_matrix[3][2], equality_matrix[3][3], equality_matrix[3][4],
        equality_matrix[4][0], equality_matrix[4][1], equality_matrix[4][2], equality_matrix[4][3], equality_matrix[4][4]
    };

endmodule