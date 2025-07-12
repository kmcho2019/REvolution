module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic remains simple
    assign out = state[3];

    // Matrix-style transition implementation
    wire [3:0] trans_matrix_0 = 4'b0101; // Next states when in=0 (A->A, B->C, C->A, D->C)
    wire [3:0] trans_matrix_1 = 4'b0010; // Next states when in=1 (A->B, B->B, C->D, D->B)

    // Select appropriate transition matrix based on input
    wire [3:0] selected_matrix = in ? trans_matrix_1 : trans_matrix_0;

    // Compute next_state through bitwise operations
    assign next_state[0] = |(state & 4'b0101) & selected_matrix[0];
    assign next_state[1] = |(state & 4'b1010) & selected_matrix[1];
    assign next_state[2] = |(state & 4'b0101) & selected_matrix[2];
    assign next_state[3] = |(state & 4'b0100) & selected_matrix[3];

endmodule