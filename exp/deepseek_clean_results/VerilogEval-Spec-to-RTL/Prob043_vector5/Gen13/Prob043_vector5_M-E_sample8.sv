module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Create 5-bit replicated versions of each input
    wire [4:0] a_vec = {5{a}};
    wire [4:0] b_vec = {5{b}};
    wire [4:0] c_vec = {5{c}};
    wire [4:0] d_vec = {5{d}};
    wire [4:0] e_vec = {5{e}};

    // Create comparison matrix (5x5 bits)
    wire [4:0] comp_matrix [4:0];
    assign comp_matrix[0] = ~(a_vec ^ {a,b,c,d,e});
    assign comp_matrix[1] = ~(b_vec ^ {a,b,c,d,e});
    assign comp_matrix[2] = ~(c_vec ^ {a,b,c,d,e});
    assign comp_matrix[3] = ~(d_vec ^ {a,b,c,d,e});
    assign comp_matrix[4] = ~(e_vec ^ {a,b,c,d,e});

    // Flatten matrix into output with correct ordering
    assign out = {
        comp_matrix[4][4], comp_matrix[4][3], comp_matrix[4][2], comp_matrix[4][1], comp_matrix[4][0],
        comp_matrix[3][4], comp_matrix[3][3], comp_matrix[3][2], comp_matrix[3][1], comp_matrix[3][0],
        comp_matrix[2][4], comp_matrix[2][3], comp_matrix[2][2], comp_matrix[2][1], comp_matrix[2][0],
        comp_matrix[1][4], comp_matrix[1][3], comp_matrix[1][2], comp_matrix[1][1], comp_matrix[1][0],
        comp_matrix[0][4], comp_matrix[0][3], comp_matrix[0][2], comp_matrix[0][1], comp_matrix[0][0]
    };

endmodule