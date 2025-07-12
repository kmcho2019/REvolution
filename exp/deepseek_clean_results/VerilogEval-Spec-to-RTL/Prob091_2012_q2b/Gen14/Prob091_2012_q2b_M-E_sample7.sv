module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State transition matrix decoder implementation
    wire [5:0] next_state;

    // Transition matrix:
    // Indexed by [current_state][w]
    // Each entry represents the next state
    // Format: A(0), B(1), C(2), D(3), E(4), F(5)
    reg [2:0] transition_matrix [0:5][0:1];

    initial begin
        // Initialize transition matrix
        // A transitions
        transition_matrix[0][0] = 0; // A->A
        transition_matrix[0][1] = 1; // A->B
        
        // B transitions
        transition_matrix[1][0] = 3; // B->D
        transition_matrix[1][1] = 2; // B->C
        
        // C transitions
        transition_matrix[2][0] = 3; // C->D
        transition_matrix[2][1] = 4; // C->E
        
        // D transitions
        transition_matrix[3][0] = 0; // D->A
        transition_matrix[3][1] = 5; // D->F
        
        // E transitions
        transition_matrix[4][0] = 3; // E->D
        transition_matrix[4][1] = 4; // E->E
        
        // F transitions
        transition_matrix[5][0] = 3; // F->D
        transition_matrix[5][1] = 2; // F->C
    end

    // Determine current state index (one-hot to binary)
    wire [2:0] current_state;
    assign current_state = y[0] ? 0 :
                          y[1] ? 1 :
                          y[2] ? 2 :
                          y[3] ? 3 :
                          y[4] ? 4 :
                          y[5] ? 5 : 0;

    // Get next state from matrix
    wire [2:0] next_state_idx = transition_matrix[current_state][w];

    // Generate Y1 (next state bit 1) and Y3 (next state bit 3)
    assign Y1 = (next_state_idx == 1);
    assign Y3 = (next_state_idx == 3);

endmodule