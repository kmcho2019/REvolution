module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - optimized continuous assignments
assign out1 = |state[9:8];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

wire not_in = ~in;

always @(*) begin
    next_state = 10'b0;
    
    // Handle all states in parallel using bitwise operations
    // S0-S4 transitions
    next_state[0] = |(state[4:0] & {5{not_in}});  // All S0-S4 go to S0 on 0
    next_state[1] = (state[0] & in) | (|state[9:8] & in);  // S0->S1 or S8/S9->S1
    next_state[2] = state[1] & in;
    next_state[3] = state[2] & in;
    next_state[4] = state[3] & in;
    next_state[5] = state[4] & in;
    
    // S5-S6 transitions
    next_state[6] = state[5] & in;
    next_state[8] = state[5] & not_in;
    next_state[7] = state[6] & in;
    next_state[9] = state[6] & not_in;
    
    // S7 transition (special case)
    next_state[0] = next_state[0] | (state[7] & not_in);
    next_state[7] = state[7] & in;
    
    // S8-S9 transitions already handled in S1 transition
end

endmodule