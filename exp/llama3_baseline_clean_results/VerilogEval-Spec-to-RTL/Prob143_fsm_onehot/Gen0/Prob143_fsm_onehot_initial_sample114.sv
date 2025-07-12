module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state and output values to zero
    assign next_state = 10'b0;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // S0 (state[0]) transitions
    if (state[0] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[0] && in) begin
        assign next_state[1] = 1'b1;
    end

    // S1 (state[1]) transitions
    if (state[1] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[1] && in) begin
        assign next_state[2] = 1'b1;
    end

    // S2 (state[2]) transitions
    if (state[2] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[2] && in) begin
        assign next_state[3] = 1'b1;
    end

    // S3 (state[3]) transitions
    if (state[3] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[3] && in) begin
        assign next_state[4] = 1'b1;
    end

    // S4 (state[4]) transitions
    if (state[4] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[4] && in) begin
        assign next_state[5] = 1'b1;
    end

    // S5 (state[5]) transitions
    if (state[5] && !in) begin
        assign next_state[8] = 1'b1;
    end else if (state[5] && in) begin
        assign next_state[6] = 1'b1;
    end

    // S6 (state[6]) transitions
    if (state[6] && !in) begin
        assign next_state[9] = 1'b1;
    end else if (state[6] && in) begin
        assign next_state[7] = 1'b1;
    end

    // S7 (state[7]) transitions
    if (state[7] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[7] && in) begin
        assign next_state[7] = 1'b1;
        assign out2 = 1'b1;
    end

    // S8 (state[8]) transitions
    if (state[8] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[8] && in) begin
        assign next_state[1] = 1'b1;
        assign out1 = 1'b1;
    end

    // S9 (state[9]) transitions
    if (state[9] && !in) begin
        assign next_state[0] = 1'b1;
    end else if (state[9] && in) begin
        assign next_state[1] = 1'b1;
        assign out1 = 1'b1;
        assign out2 = 1'b1;
    end

endmodule