module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Input vector
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Comparison matrix
    wire [4:0][4:0] comp_matrix;
    
    // Generate comparison matrix
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign comp_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
    
    // Flatten matrix into output vector (row-major order)
    assign out = {
        comp_matrix[4][4], comp_matrix[4][3], comp_matrix[4][2], comp_matrix[4][1], comp_matrix[4][0],
        comp_matrix[3][4], comp_matrix[3][3], comp_matrix[3][2], comp_matrix[3][1], comp_matrix[3][0],
        comp_matrix[2][4], comp_matrix[2][3], comp_matrix[2][2], comp_matrix[2][1], comp_matrix[2][0],
        comp_matrix[1][4], comp_matrix[1][3], comp_matrix[1][2], comp_matrix[1][1], comp_matrix[1][0],
        comp_matrix[0][4], comp_matrix[0][3], comp_matrix[0][2], comp_matrix[0][1], comp_matrix[0][0]
    };

endmodule