module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = {10{1'b0}}; // Initialize next_state to all zeros
    assign out1 = 1'b0; // Initialize out1 to 0
    assign out2 = 1'b0; // Initialize out2 to 0

    // S0
    if (state[0] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Stay in S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
    end

    // S1
    if (state[1] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[2] = 1'b1; // Transition to S2
        end
    end

    // S2
    if (state[2] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[3] = 1'b1; // Transition to S3
        end
    end

    // S3
    if (state[3] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[4] = 1'b1; // Transition to S4
        end
    end

    // S4
    if (state[4] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[5] = 1'b1; // Transition to S5
        end
    end

    // S5
    if (state[5] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[8] = 1'b1; // Transition to S8
        end else begin
            next_state[6] = 1'b1; // Transition to S6
        end
    end

    // S6
    if (state[6] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[9] = 1'b1; // Transition to S9
        end else begin
            next_state[7] = 1'b1; // Transition to S7
        end
    end

    // S7
    if (state[7] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[7] = 1'b1; // Stay in S7
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end

    // S8
    if (state[8] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end

    // S9
    if (state[9] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end

endmodule