module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to 0
assign next_state = 10'b0;

// Determine next state and outputs based on current state and input
always @(state, in) begin
    case (1'b1)
        state[0]: // S0
            if (in) begin
                next_state[1] = 1'b1; // Go to S1
            end else begin
                next_state[0] = 1'b1; // Stay in S0
            end
        state[1]: // S1
            if (in) begin
                next_state[2] = 1'b1; // Go to S2
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
        state[2]: // S2
            if (in) begin
                next_state[3] = 1'b1; // Go to S3
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
        state[3]: // S3
            if (in) begin
                next_state[4] = 1'b1; // Go to S4
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
        state[4]: // S4
            if (in) begin
                next_state[5] = 1'b1; // Go to S5
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
        state[5]: // S5
            if (in) begin
                next_state[6] = 1'b1; // Go to S6
            end else begin
                next_state[8] = 1'b1; // Go to S8
            end
        state[6]: // S6
            if (in) begin
                next_state[7] = 1'b1; // Go to S7
            end else begin
                next_state[9] = 1'b1; // Go to S9
            end
        state[7]: // S7
            if (in) begin
                next_state[7] = 1'b1; // Stay in S7
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
        state[8]: // S8
            if (in) begin
                next_state[1] = 1'b1; // Go to S1
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
        state[9]: // S9
            if (in) begin
                next_state[1] = 1'b1; // Go to S1
            end else begin
                next_state[0] = 1'b1; // Go to S0
            end
    endcase
end

// Determine outputs based on current state
assign out1 = (state[8] | state[9]);
assign out2 = (state[7] | state[9]);

endmodule