module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Combine inputs into a vector
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate comparison matrix
    wire [4:0][4:0] cmp_matrix;
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign cmp_matrix[i][j] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate
    
    // Flatten matrix into output vector (row-major order)
    assign out = {
        cmp_matrix[4][4], cmp_matrix[4][3], cmp_matrix[4][2], cmp_matrix[4][1], cmp_matrix[4][0],
        cmp_matrix[3][4], cmp_matrix[3][3], cmp_matrix[3][2], cmp_matrix[3][1], cmp_matrix[3][0],
        cmp_matrix[2][4], cmp_matrix[2][3], cmp_matrix[2][2], cmp_matrix[2][1], cmp_matrix[2][0],
        cmp_matrix[1][4], cmp_matrix[1][3], cmp_matrix[1][2], cmp_matrix[1][1], cmp_matrix[1][0],
        cmp_matrix[0][4], cmp_matrix[0][3], cmp_matrix[0][2], cmp_matrix[0][1], cmp_matrix[0][0]
    };

endmodule