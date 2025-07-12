module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - optimized using state groupings
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |state[9:7];  // S7 or S9

always @(*) begin
    // Default all bits to 0
    next_state = 10'b0;
    
    // Handle S0 transitions
    if (state[0]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
    
    // Handle S1-S4 group (all have same pattern: ~in->S0, in->next)
    if (|state[4:1]) begin
        next_state[0] = next_state[0] | (~in);
        if (state[1]) next_state[2] = in;
        if (state[2]) next_state[3] = in;
        if (state[3]) next_state[4] = in;
        if (state[4]) next_state[5] = in;
    end
    
    // Handle S5-S6 group (unique transitions)
    if (state[5]) begin
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = ~in;
        next_state[7] = in;
    end
    
    // Handle S7 (self-loop)
    if (state[7]) begin
        next_state[0] = next_state[0] | ~in;
        next_state[7] = in;
    end
    
    // Handle S8-S9 group (identical transitions)
    if (|state[9:8]) begin
        next_state[0] = next_state[0] | ~in;
        next_state[1] = next_state[1] | in;
    end
end

endmodule