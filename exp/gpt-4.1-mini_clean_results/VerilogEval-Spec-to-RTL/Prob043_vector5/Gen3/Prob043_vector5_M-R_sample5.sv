module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    wire [4:0][4:0] eq_matrix;

    // Assign pairwise equalities explicitly
    assign eq_matrix[0][0] = ~(a ^ a);
    assign eq_matrix[0][1] = ~(a ^ b);
    assign eq_matrix[0][2] = ~(a ^ c);
    assign eq_matrix[0][3] = ~(a ^ d);
    assign eq_matrix[0][4] = ~(a ^ e);

    assign eq_matrix[1][0] = ~(b ^ a);
    assign eq_matrix[1][1] = ~(b ^ b);
    assign eq_matrix[1][2] = ~(b ^ c);
    assign eq_matrix[1][3] = ~(b ^ d);
    assign eq_matrix[1][4] = ~(b ^ e);

    assign eq_matrix[2][0] = ~(c ^ a);
    assign eq_matrix[2][1] = ~(c ^ b);
    assign eq_matrix[2][2] = ~(c ^ c);
    assign eq_matrix[2][3] = ~(c ^ d);
    assign eq_matrix[2][4] = ~(c ^ e);

    assign eq_matrix[3][0] = ~(d ^ a);
    assign eq_matrix[3][1] = ~(d ^ b);
    assign eq_matrix[3][2] = ~(d ^ c);
    assign eq_matrix[3][3] = ~(d ^ d);
    assign eq_matrix[3][4] = ~(d ^ e);

    assign eq_matrix[4][0] = ~(e ^ a);
    assign eq_matrix[4][1] = ~(e ^ b);
    assign eq_matrix[4][2] = ~(e ^ c);
    assign eq_matrix[4][3] = ~(e ^ d);
    assign eq_matrix[4][4] = ~(e ^ e);

    // Flatten eq_matrix row-wise from top (0) to bottom (4), each row left (0) to right (4)
    assign out = {eq_matrix[0], eq_matrix[1], eq_matrix[2], eq_matrix[3], eq_matrix[4]};

endmodule