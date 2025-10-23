module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0;  // Initialize next_state to 0
        out1 = 0;  // Initialize out1 to 0
        out2 = 0;  // Initialize out2 to 0

        // Determine next state and outputs based on current state and input
        if (state[0]) begin  // S0
            if (in) next_state[1] = 1;  // Transition to S1 on input 1
            else next_state[0] = 1;  // Stay in S0 on input 0
        end
        else if (state[1]) begin  // S1
            if (in) next_state[2] = 1;  // Transition to S2 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
        end
        else if (state[2]) begin  // S2
            if (in) next_state[3] = 1;  // Transition to S3 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
        end
        else if (state[3]) begin  // S3
            if (in) next_state[4] = 1;  // Transition to S4 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
        end
        else if (state[4]) begin  // S4
            if (in) next_state[5] = 1;  // Transition to S5 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
        end
        else if (state[5]) begin  // S5
            if (in) next_state[6] = 1;  // Transition to S6 on input 1
            else next_state[8] = 1;  // Transition to S8 on input 0
        end
        else if (state[6]) begin  // S6
            if (in) next_state[7] = 1;  // Transition to S7 on input 1
            else next_state[9] = 1;  // Transition to S9 on input 0
        end
        else if (state[7]) begin  // S7
            if (in) next_state[7] = 1;  // Stay in S7 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
            out2 = 1;  // Set out2 to 1 in S7
        end
        else if (state[8]) begin  // S8
            if (in) next_state[1] = 1;  // Transition to S1 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
            out1 = 1;  // Set out1 to 1 in S8
        end
        else if (state[9]) begin  // S9
            if (in) next_state[1] = 1;  // Transition to S1 on input 1
            else next_state[0] = 1;  // Transition to S0 on input 0
            out1 = 1;  // Set out1 to 1 in S9
            out2 = 1;  // Set out2 to 1 in S9
        end
    end
endmodule