module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to all zeros
    assign next_state = 10'b0;

    // Initialize outputs to zero unless specified otherwise
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // State machine transitions
    // S0 transitions
    if (state[0] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Stay in S0
    end else if (state[0] == 1'b1 && in == 1'b1) begin
        assign next_state[1] = 1'b1; // Go to S1
    end

    // S1 transitions
    if (state[1] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[1] == 1'b1 && in == 1'b1) begin
        assign next_state[2] = 1'b1; // Go to S2
    end

    // S2 transitions
    if (state[2] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[2] == 1'b1 && in == 1'b1) begin
        assign next_state[3] = 1'b1; // Go to S3
    end

    // S3 transitions
    if (state[3] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[3] == 1'b1 && in == 1'b1) begin
        assign next_state[4] = 1'b1; // Go to S4
    end

    // S4 transitions
    if (state[4] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[4] == 1'b1 && in == 1'b1) begin
        assign next_state[5] = 1'b1; // Go to S5
    end

    // S5 transitions
    if (state[5] == 1'b1 && in == 1'b0) begin
        assign next_state[8] = 1'b1; // Go to S8
    end else if (state[5] == 1'b1 && in == 1'b1) begin
        assign next_state[6] = 1'b1; // Go to S6
    end

    // S6 transitions
    if (state[6] == 1'b1 && in == 1'b0) begin
        assign next_state[9] = 1'b1; // Go to S9
    end else if (state[6] == 1'b1 && in == 1'b1) begin
        assign next_state[7] = 1'b1; // Go to S7
    end

    // S7 transitions
    if (state[7] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[7] == 1'b1 && in == 1'b1) begin
        assign next_state[7] = 1'b1; // Stay in S7
        assign out1 = 1'b0; // Output out1 is 0 for S7
        assign out2 = 1'b1; // Output out2 is 1 for S7
    end

    // S8 transitions
    if (state[8] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[8] == 1'b1 && in == 1'b1) begin
        assign next_state[1] = 1'b1; // Go to S1
    end
    if (state[8] == 1'b1) begin
        assign out1 = 1'b1; // Output out1 is 1 for S8
        assign out2 = 1'b0; // Output out2 is 0 for S8
    end

    // S9 transitions
    if (state[9] == 1'b1 && in == 1'b0) begin
        assign next_state[0] = 1'b1; // Go to S0
    end else if (state[9] == 1'b1 && in == 1'b1) begin
        assign next_state[1] = 1'b1; // Go to S1
    end
    if (state[9] == 1'b1) begin
        assign out1 = 1'b1; // Output out1 is 1 for S9
        assign out2 = 1'b1; // Output out2 is 1 for S9
    end

endmodule