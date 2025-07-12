module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to all zeros to avoid latches
assign next_state = 10'b0;
assign out1 = 1'b0;
assign out2 = 1'b0;

// Determine next state and outputs based on current state and input
always @(*) begin
    if (state[0] == 1'b1) begin // State S0
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Stay in S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
    end else if (state[1] == 1'b1) begin // State S1
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[2] = 1'b1; // Transition to S2
        end
    end else if (state[2] == 1'b1) begin // State S2
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[3] = 1'b1; // Transition to S3
        end
    end else if (state[3] == 1'b1) begin // State S3
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[4] = 1'b1; // Transition to S4
        end
    end else if (state[4] == 1'b1) begin // State S4
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[5] = 1'b1; // Transition to S5
        end
    end else if (state[5] == 1'b1) begin // State S5
        if (in == 1'b0) begin
            next_state[8] = 1'b1; // Transition to S8
        end else begin
            next_state[6] = 1'b1; // Transition to S6
        end
    end else if (state[6] == 1'b1) begin // State S6
        if (in == 1'b0) begin
            next_state[9] = 1'b1; // Transition to S9
        end else begin
            next_state[7] = 1'b1; // Transition to S7
        end
    end else if (state[7] == 1'b1) begin // State S7
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[7] = 1'b1; // Stay in S7
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end else if (state[8] == 1'b1) begin // State S8
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end else if (state[9] == 1'b1) begin // State S9
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Transition to S0
        end else begin
            next_state[1] = 1'b1; // Transition to S1
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule