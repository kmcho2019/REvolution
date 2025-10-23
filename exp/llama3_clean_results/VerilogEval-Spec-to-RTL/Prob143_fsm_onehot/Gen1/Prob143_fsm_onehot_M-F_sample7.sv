module TopModule(
    input  in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Determine the next state based on the current state and input
always @(*) begin
    next_state = 10'b0000000000; // Initialize next_state to all zeros
    out1 = 1'b0; // Initialize out1 to zero
    out2 = 1'b0; // Initialize out2 to zero

    // Check each possible state and input combination
    if (state[0] & ~in) begin
        next_state[0] = 1'b1;
    end else if (state[0] & in) begin
        next_state[1] = 1'b1;
    end else if (state[1] & ~in) begin
        next_state[0] = 1'b1;
    end else if (state[1] & in) begin
        next_state[2] = 1'b1;
    end else if (state[2] & ~in) begin
        next_state[0] = 1'b1;
    end else if (state[2] & in) begin
        next_state[3] = 1'b1;
    end else if (state[3] & ~in) begin
        next_state[0] = 1'b1;
    end else if (state[3] & in) begin
        next_state[4] = 1'b1;
    end else if (state[4] & ~in) begin
        next_state[0] = 1'b1;
    end else if (state[4] & in) begin
        next_state[5] = 1'b1;
    end else if (state[5] & ~in) begin
        next_state[8] = 1'b1;
    end else if (state[5] & in) begin
        next_state[6] = 1'b1;
    end else if (state[6] & ~in) begin
        next_state[9] = 1'b1;
    end else if (state[6] & in) begin
        next_state[7] = 1'b1;
    end else if (state[7] & ~in) begin
        next_state[0] = 1'b1;
        out2 = 1'b1; // Set out2 to 1 when in current state S7 and input is 0
    end else if (state[7] & in) begin
        next_state[7] = 1'b1;
        out2 = 1'b1; // Set out2 to 1 when in current state S7 and input is 1
    end else if (state[8] & ~in) begin
        next_state[0] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 when in current state S8 and input is 0
    end else if (state[8] & in) begin
        next_state[1] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 when in current state S8 and input is 1
    end else if (state[9] & ~in) begin
        next_state[0] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 when in current state S9 and input is 0
        out2 = 1'b1; // Set out2 to 1 when in current state S9 and input is 0
    end else if (state[9] & in) begin
        next_state[1] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 when in current state S9 and input is 1
        out2 = 1'b1; // Set out2 to 1 when in current state S9 and input is 1
    end
end

endmodule