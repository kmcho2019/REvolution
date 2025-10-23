module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);
    // Create a 5x5 comparison matrix
    wire [4:0][4:0] comp_matrix;

    // Diagonal elements (always 1)
    assign comp_matrix[0][0] = 1'b1;
    assign comp_matrix[1][1] = 1'b1;
    assign comp_matrix[2][2] = 1'b1;
    assign comp_matrix[3][3] = 1'b1;
    assign comp_matrix[4][4] = 1'b1;

    // Upper triangular comparisons
    assign comp_matrix[0][1] = (a == b);
    assign comp_matrix[0][2] = (a == c);
    assign comp_matrix[0][3] = (a == d);
    assign comp_matrix[0][4] = (a == e);
    
    assign comp_matrix[1][2] = (b == c);
    assign comp_matrix[1][3] = (b == d);
    assign comp_matrix[1][4] = (b == e);
    
    assign comp_matrix[2][3] = (c == d);
    assign comp_matrix[2][4] = (c == e);
    
    assign comp_matrix[3][4] = (d == e);

    // Mirror lower triangular portion
    assign comp_matrix[1][0] = comp_matrix[0][1];
    assign comp_matrix[2][0] = comp_matrix[0][2];
    assign comp_matrix[3][0] = comp_matrix[0][3];
    assign comp_matrix[4][0] = comp_matrix[0][4];
    
    assign comp_matrix[2][1] = comp_matrix[1][2];
    assign comp_matrix[3][1] = comp_matrix[1][3];
    assign comp_matrix[4][1] = comp_matrix[1][4];
    
    assign comp_matrix[3][2] = comp_matrix[2][3];
    assign comp_matrix[4][2] = comp_matrix[2][4];
    
    assign comp_matrix[4][3] = comp_matrix[3][4];

    // Flatten matrix into output vector (row-major order)
    assign out = {
        comp_matrix[4][4], comp_matrix[4][3], comp_matrix[4][2], comp_matrix[4][1], comp_matrix[4][0],
        comp_matrix[3][4], comp_matrix[3][3], comp_matrix[3][2], comp_matrix[3][1], comp_matrix[3][0],
        comp_matrix[2][4], comp_matrix[2][3], comp_matrix[2][2], comp_matrix[2][1], comp_matrix[2][0],
        comp_matrix[1][4], comp_matrix[1][3], comp_matrix[1][2], comp_matrix[1][1], comp_matrix[1][0],
        comp_matrix[0][4], comp_matrix[0][3], comp_matrix[0][2], comp_matrix[0][1], comp_matrix[0][0]
    };
endmodule