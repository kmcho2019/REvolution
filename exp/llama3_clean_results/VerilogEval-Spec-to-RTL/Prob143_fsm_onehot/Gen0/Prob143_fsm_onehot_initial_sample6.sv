module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state with zeros
assign next_state = {10{1'b0}};

// Output logic
assign out1 = (state[8] | state[9]);
assign out2 = (state[7] | state[9]);

// State transition logic
always @(state, in) begin
    if (state[0] == 1'b1) begin // S0
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Stay in S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
    end

    if (state[1] == 1'b1) begin // S1
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[2] = 1'b1; // Transition to S2
        end
    end

    if (state[2] == 1'b1) begin // S2
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[3] = 1'b1; // Transition to S3
        end
    end

    if (state[3] == 1'b1) begin // S3
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[4] = 1'b1; // Transition to S4
        end
    end

    if (state[4] == 1'b1) begin // S4
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[5] = 1'b1; // Transition to S5
        end
    end

    if (state[5] == 1'b1) begin // S5
        if (in == 1'b0) begin
            next_state[8] = 1'b1; // Transition to S8
        end else begin
            next_state[6] = 1'b1; // Transition to S6
        end
    end

    if (state[6] == 1'b1) begin // S6
        if (in == 1'b0) begin
            next_state[9] = 1'b1; // Transition to S9
        end else begin
            next_state[7] = 1'b1; // Transition to S7
        end
    end

    if (state[7] == 1'b1) begin // S7
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[7] = 1'b1; // Stay in S7
        end
    end

    if (state[8] == 1'b1) begin // S8
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
    end

    if (state[9] == 1'b1) begin // S9
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
    end
end

endmodule