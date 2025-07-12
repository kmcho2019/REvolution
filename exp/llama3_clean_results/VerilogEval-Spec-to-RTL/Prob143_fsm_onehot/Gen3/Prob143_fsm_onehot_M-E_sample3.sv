module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define the state transition matrix
    reg [9:0] state_transition_matrix [10][2];

    // Initialize the state transition matrix
    initial begin
        // S0 transitions
        state_transition_matrix[0][0] = 10'b1;
        state_transition_matrix[0][1] = 10'b10;

        // S1 transitions
        state_transition_matrix[1][0] = 10'b1;
        state_transition_matrix[1][1] = 10'b100;

        // S2 transitions
        state_transition_matrix[2][0] = 10'b1;
        state_transition_matrix[2][1] = 10'b1000;

        // S3 transitions
        state_transition_matrix[3][0] = 10'b1;
        state_transition_matrix[3][1] = 10'b10000;

        // S4 transitions
        state_transition_matrix[4][0] = 10'b1;
        state_transition_matrix[4][1] = 10'b100000;

        // S5 transitions
        state_transition_matrix[5][0] = 10'b100000000;
        state_transition_matrix[5][1] = 10'b1000000;

        // S6 transitions
        state_transition_matrix[6][0] = 10'b1000000000;
        state_transition_matrix[6][1] = 10'b10000000;

        // S7 transitions
        state_transition_matrix[7][0] = 10'b1;
        state_transition_matrix[7][1] = 10'b10000000;

        // S8 transitions
        state_transition_matrix[8][0] = 10'b1;
        state_transition_matrix[8][1] = 10'b10;

        // S9 transitions
        state_transition_matrix[9][0] = 10'b1;
        state_transition_matrix[9][1] = 10'b10;
    end

    // Determine next state based on current state and input
    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // Iterate over each state bit
        for (int i = 0; i < 10; i++) begin
            if (state[i] == 1'b1) begin
                // Get the next state from the state transition matrix
                next_state = next_state | state_transition_matrix[i][in];
            end
        end

        // Determine output values based on next state
        if (next_state[7] == 1'b1) begin
            out2 = 1'b1;
        end
        if (next_state[8] == 1'b1) begin
            out1 = 1'b1;
            out2 = 1'b0;
        end
        if (next_state[9] == 1'b1) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule