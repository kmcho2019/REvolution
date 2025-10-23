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

// Common signals
wire not_in = ~in;

always @(*) begin
    next_state = 10'b0;
    
    // S0-S4 transitions (all go to S0 on 0)
    next_state[0] = |state[4:0] & not_in;
    if (state[0]) next_state[1] = in;
    if (state[1]) next_state[2] = in;
    if (state[2]) next_state[3] = in;
    if (state[3]) next_state[4] = in;
    if (state[4]) next_state[5] = in;
    
    // S5 transitions
    next_state[8] = state[5] & not_in;
    next_state[6] = state[5] & in;
    
    // S6 transitions
    next_state[9] = state[6] & not_in;
    next_state[7] = state[6] & in;
    
    // S7 transitions
    next_state[0] = next_state[0] | (state[7] & not_in);
    next_state[7] = state[7] & in;
    
    // S8/S9 transitions (identical)
    next_state[0] = next_state[0] | (|state[9:8] & not_in);
    next_state[1] = |state[9:8] & in;
end

endmodule