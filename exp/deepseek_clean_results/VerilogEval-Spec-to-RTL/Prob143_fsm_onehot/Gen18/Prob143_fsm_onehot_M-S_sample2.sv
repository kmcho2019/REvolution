module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    next_state = 10'b0;
    
    // Handle all states in parallel
    if (state[0]) begin          // S0
        next_state[0] = ~in;
        next_state[1] = in;
    end
    
    // S1-S4 share same transition pattern
    if (|state[4:1]) begin
        next_state[0] = next_state[0] | (~in & |state[4:1]);
        next_state[{state[1], state[2], state[3], state[4], 1'b0} + 2] = in & |state[4:1];
    end
    
    // S5 and S6
    if (state[5]) begin
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = ~in;
        next_state[7] = in;
    end
    
    // S7
    if (state[7]) begin
        next_state[0] = next_state[0] | ~in;
        next_state[7] = in;
    end
    
    // S8 and S9 share same transitions
    if (|state[9:8]) begin
        next_state[0] = next_state[0] | ~in;
        next_state[1] = next_state[1] | in;
    end
end

endmodule