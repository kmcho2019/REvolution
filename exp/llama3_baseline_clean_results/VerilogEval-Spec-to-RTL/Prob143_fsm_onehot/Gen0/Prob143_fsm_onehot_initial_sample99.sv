module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to 0
assign next_state = 10'b0;

// Output logic
assign out1 = (state[8] | state[9]);
assign out2 = (state[7] | state[9]);

// Next state logic
always @(state, in) begin
    if (state[0] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[0] && in) begin
        next_state[1] = 1'b1;
    end else if (state[1] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[1] && in) begin
        next_state[2] = 1'b1;
    end else if (state[2] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[2] && in) begin
        next_state[3] = 1'b1;
    end else if (state[3] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[3] && in) begin
        next_state[4] = 1'b1;
    end else if (state[4] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[4] && in) begin
        next_state[5] = 1'b1;
    end else if (state[5] && !in) begin
        next_state[8] = 1'b1;
    end else if (state[5] && in) begin
        next_state[6] = 1'b1;
    end else if (state[6] && !in) begin
        next_state[9] = 1'b1;
    end else if (state[6] && in) begin
        next_state[7] = 1'b1;
    end else if (state[7] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[7] && in) begin
        next_state[7] = 1'b1;
    end else if (state[8] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[8] && in) begin
        next_state[1] = 1'b1;
    end else if (state[9] && !in) begin
        next_state[0] = 1'b1;
    end else if (state[9] && in) begin
        next_state[1] = 1'b1;
    end
end

endmodule