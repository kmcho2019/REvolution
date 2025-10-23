module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - more efficient continuous assignments
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    next_state = 10'b0;
    
    // Handle transitions using more efficient logic
    if (|state[4:0]) begin // S0-S4 share similar transition patterns
        next_state[0] = ~in;
        if (state[0]) next_state[1] = in;
        if (state[1]) next_state[2] = in;
        if (state[2]) next_state[3] = in;
        if (state[3]) next_state[4] = in;
        if (state[4]) next_state[5] = in;
    end
    
    // S5 and S6 have unique transitions
    if (state[5]) begin
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = ~in;
        next_state[7] = in;
    end
    
    // S7-S9 transitions
    if (state[7]) begin
        next_state[0] = next_state[0] | ~in;
        next_state[7] = in;
    end
    if (|state[9:8]) begin // S8 and S9 share same transitions
        next_state[0] = next_state[0] | ~in;
        next_state[1] = next_state[1] | in;
    end
end

endmodule