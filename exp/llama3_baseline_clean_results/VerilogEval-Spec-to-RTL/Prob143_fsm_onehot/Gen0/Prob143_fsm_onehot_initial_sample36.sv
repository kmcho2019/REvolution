module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state and outputs
assign next_state = 10'b0;
assign out1 = 0;
assign out2 = 0;

// S0 transitions
if (state[0]) begin
    if (!in) begin
        next_state[0] = 1; // Stay in S0
    end else begin
        next_state[1] = 1; // Transition to S1
    end
end

// S1 transitions
if (state[1]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[2] = 1; // Transition to S2
    end
end

// S2 transitions
if (state[2]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[3] = 1; // Transition to S3
    end
end

// S3 transitions
if (state[3]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[4] = 1; // Transition to S4
    end
end

// S4 transitions
if (state[4]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[5] = 1; // Transition to S5
    end
end

// S5 transitions
if (state[5]) begin
    if (!in) begin
        next_state[8] = 1; // Transition to S8
    end else begin
        next_state[6] = 1; // Transition to S6
    end
end

// S6 transitions
if (state[6]) begin
    if (!in) begin
        next_state[9] = 1; // Transition to S9
    end else begin
        next_state[7] = 1; // Transition to S7
    end
end

// S7 transitions
if (state[7]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[7] = 1; // Stay in S7
    end
    out2 = 1; // Set out2 for S7
end

// S8 transitions
if (state[8]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[1] = 1; // Transition to S1
    end
    out1 = 1; // Set out1 for S8
end

// S9 transitions
if (state[9]) begin
    if (!in) begin
        next_state[0] = 1; // Transition to S0
    end else begin
        next_state[1] = 1; // Transition to S1
    end
    out1 = 1; // Set out1 for S9
    out2 = 1; // Set out2 for S9
end

endmodule