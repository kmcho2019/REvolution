module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic (only depends on current state)
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

// Next state logic
always @(*) begin
    next_state = 10'b0;
    
    // Common transitions to S0 when input is 0
    if (~in) begin
        next_state[0] = |state[7:0] | state[8] | state[9];
    end
    
    // State-specific transitions when input is 1
    if (in) begin
        next_state[1] = state[0] | state[8] | state[9];
        next_state[2] = state[1];
        next_state[3] = state[2];
        next_state[4] = state[3];
        next_state[5] = state[4];
        next_state[6] = state[5];
        next_state[7] = state[6] | state[7];
        next_state[8] = state[5];
        next_state[9] = state[6];
    end
end

endmodule