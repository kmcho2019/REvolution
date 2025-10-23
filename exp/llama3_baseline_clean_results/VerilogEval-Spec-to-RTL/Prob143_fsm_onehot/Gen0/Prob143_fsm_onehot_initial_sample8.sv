module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to 0
    assign next_state = {10{1'b0}};

    // Initialize out1 and out2 to 0
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Apply state transition logic
    always @(state, in) begin
        if (state[0]) begin  // S0
            if (!in) next_state[0] = 1'b1;
            else next_state[1] = 1'b1;
        end
        if (state[1]) begin  // S1
            if (!in) next_state[0] = 1'b1;
            else next_state[2] = 1'b1;
        end
        if (state[2]) begin  // S2
            if (!in) next_state[0] = 1'b1;
            else next_state[3] = 1'b1;
        end
        if (state[3]) begin  // S3
            if (!in) next_state[0] = 1'b1;
            else next_state[4] = 1'b1;
        end
        if (state[4]) begin  // S4
            if (!in) next_state[0] = 1'b1;
            else next_state[5] = 1'b1;
        end
        if (state[5]) begin  // S5
            if (!in) next_state[8] = 1'b1;
            else next_state[6] = 1'b1;
        end
        if (state[6]) begin  // S6
            if (!in) next_state[9] = 1'b1;
            else next_state[7] = 1'b1;
        end
        if (state[7]) begin  // S7
            if (!in) next_state[0] = 1'b1;
            else next_state[7] = 1'b1;
            if (state[7] && !in) out2 = 1'b1;
            else if (state[7] && in) out2 = 1'b1;
        end
        if (state[8]) begin  // S8
            if (!in) next_state[0] = 1'b1;
            else next_state[1] = 1'b1;
            if (state[8]) out1 = 1'b1;
        end
        if (state[9]) begin  // S9
            if (!in) next_state[0] = 1'b1;
            else next_state[1] = 1'b1;
            if (state[9]) out1 = 1'b1;
            if (state[9]) out2 = 1'b1;
        end
    end
endmodule