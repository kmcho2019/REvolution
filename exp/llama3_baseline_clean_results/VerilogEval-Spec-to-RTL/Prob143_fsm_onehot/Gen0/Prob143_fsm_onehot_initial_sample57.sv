module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always_comb begin
    // Initialize next state and outputs
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;

    // Check each state in the combination
    for (int i = 0; i < 10; i++) begin
        if (state[i] == 1) begin
            case (i)
                0: begin // S0
                    if (!in) next_state[0] = 1; // Stay in S0
                    else next_state[1] = 1; // Transition to S1
                end
                1: begin // S1
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[2] = 1; // Transition to S2
                end
                2: begin // S2
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[3] = 1; // Transition to S3
                end
                3: begin // S3
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[4] = 1; // Transition to S4
                end
                4: begin // S4
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[5] = 1; // Transition to S5
                end
                5: begin // S5
                    if (!in) next_state[8] = 1; // Transition to S8
                    else next_state[6] = 1; // Transition to S6
                end
                6: begin // S6
                    if (!in) next_state[9] = 1; // Transition to S9
                    else next_state[7] = 1; // Transition to S7
                end
                7: begin // S7
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[7] = 1; // Stay in S7
                    out1 = 0;
                    out2 = 1;
                end
                8: begin // S8
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[1] = 1; // Transition to S1
                    out1 = 1;
                    out2 = 0;
                end
                9: begin // S9
                    if (!in) next_state[0] = 1; // Transition to S0
                    else next_state[1] = 1; // Transition to S1
                    out1 = 1;
                    out2 = 1;
                end
            endcase
        end
    end
end

endmodule