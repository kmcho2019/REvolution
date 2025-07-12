module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    // Define the state transition matrix for input = 0
    reg [9:0] state_transitions_0 [10];
    always @(*) begin
        state_transitions_0[0] = 10'b1; // S0 -> S0
        state_transitions_0[1] = 10'b1; // S1 -> S0
        state_transitions_0[2] = 10'b1; // S2 -> S0
        state_transitions_0[3] = 10'b1; // S3 -> S0
        state_transitions_0[4] = 10'b1; // S4 -> S0
        state_transitions_0[5] = 10'b100000000; // S5 -> S8
        state_transitions_0[6] = 10'b1000000000; // S6 -> S9
        state_transitions_0[7] = 10'b1; // S7 -> S0
        state_transitions_0[8] = 10'b1; // S8 -> S0
        state_transitions_0[9] = 10'b1; // S9 -> S0
    end

    // Define the state transition matrix for input = 1
    reg [9:0] state_transitions_1 [10];
    always @(*) begin
        state_transitions_1[0] = 10'b10; // S0 -> S1
        state_transitions_1[1] = 10'b100; // S1 -> S2
        state_transitions_1[2] = 10'b1000; // S2 -> S3
        state_transitions_1[3] = 10'b10000; // S3 -> S4
        state_transitions_1[4] = 10'b100000; // S4 -> S5
        state_transitions_1[5] = 10'b1000000; // S5 -> S6
        state_transitions_1[6] = 10'b10000000; // S6 -> S7
        state_transitions_1[7] = 10'b10000000; // S7 -> S7
        state_transitions_1[8] = 10'b10; // S8 -> S1
        state_transitions_1[9] = 10'b10; // S9 -> S1
    end

    // Select the appropriate state transition matrix based on the input
    reg [9:0] selected_transitions [10];
    always @(*) begin
        if (in) begin
            selected_transitions = state_transitions_1;
        end else begin
            selected_transitions = state_transitions_0;
        end
    end

    // Determine the next state based on the current state and selected transitions
    always @(*) begin
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                next_state_reg |= selected_transitions[i];
                // Output logic based on the current state and next state
                if (i == 7) begin
                    out2_reg = 1'b1;
                end else if (i == 8 || i == 9) begin
                    out1_reg = 1'b1;
                    if (i == 9) begin
                        out2_reg = 1'b1;
                    end
                end
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule