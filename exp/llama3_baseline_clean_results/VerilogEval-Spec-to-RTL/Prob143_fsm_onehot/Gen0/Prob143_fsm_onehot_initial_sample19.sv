module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to all zeros
assign next_state = 10'b0000000000;

// Determine next state based on current state and input
always @(*) begin
    if (state[0] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[0] == 1'b1 && in == 1'b1) next_state[1] = 1'b1;
    else if (state[1] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[1] == 1'b1 && in == 1'b1) next_state[2] = 1'b1;
    else if (state[2] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[2] == 1'b1 && in == 1'b1) next_state[3] = 1'b1;
    else if (state[3] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[3] == 1'b1 && in == 1'b1) next_state[4] = 1'b1;
    else if (state[4] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[4] == 1'b1 && in == 1'b1) next_state[5] = 1'b1;
    else if (state[5] == 1'b1 && in == 1'b0) next_state[8] = 1'b1;
    else if (state[5] == 1'b1 && in == 1'b1) next_state[6] = 1'b1;
    else if (state[6] == 1'b1 && in == 1'b0) next_state[9] = 1'b1;
    else if (state[6] == 1'b1 && in == 1'b1) next_state[7] = 1'b1;
    else if (state[7] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[7] == 1'b1 && in == 1'b1) next_state[7] = 1'b1;
    else if (state[8] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[8] == 1'b1 && in == 1'b1) next_state[1] = 1'b1;
    else if (state[9] == 1'b1 && in == 1'b0) next_state[0] = 1'b1;
    else if (state[9] == 1'b1 && in == 1'b1) next_state[1] = 1'b1;
end

// Determine outputs based on current state
assign out1 = (state[7] == 1'b1 || state[9] == 1'b1);
assign out2 = (state[7] == 1'b1 || state[8] == 1'b1 || state[9] == 1'b1);

endmodule