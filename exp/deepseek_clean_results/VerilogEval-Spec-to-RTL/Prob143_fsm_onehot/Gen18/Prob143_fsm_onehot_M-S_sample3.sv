module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - active only in S7-S9
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    // Default all bits to 0
    next_state = 10'b0;

    // Handle all transitions to S0
    if ((state[0] & ~in) | 
        (state[1] & ~in) | 
        (state[2] & ~in) | 
        (state[3] & ~in) | 
        (state[4] & ~in) | 
        (state[7] & ~in) | 
        (state[8] & ~in) | 
        (state[9] & ~in)) begin
        next_state[0] = 1'b1;
    end

    // Individual state transitions
    if (state[0] & in)  next_state[1] = 1'b1;
    if (state[1] & in)  next_state[2] = 1'b1;
    if (state[2] & in)  next_state[3] = 1'b1;
    if (state[3] & in)  next_state[4] = 1'b1;
    if (state[4] & in)  next_state[5] = 1'b1;
    if (state[5] & ~in) next_state[8] = 1'b1;
    if (state[5] & in)  next_state[6] = 1'b1;
    if (state[6] & ~in) next_state[9] = 1'b1;
    if (state[6] & in)  next_state[7] = 1'b1;
    if (state[7] & in)  next_state[7] = 1'b1;
    if ((state[8] | state[9]) & in) next_state[1] = 1'b1;
end

endmodule