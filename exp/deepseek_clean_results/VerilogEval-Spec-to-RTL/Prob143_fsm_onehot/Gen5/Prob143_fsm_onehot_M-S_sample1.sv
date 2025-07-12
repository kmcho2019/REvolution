module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

always @(*) begin
    next_state = 10'b0;
    
    // Handle S0-S4 (similar transition patterns)
    if (|state[4:0]) begin
        next_state[0] = ~in;
        next_state[state[4:0] + 1] = in;
    end
    
    // Handle S5-S9 individually
    if (state[5]) begin
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = ~in;
        next_state[7] = in;
    end
    if (state[7]) begin
        next_state[0] = ~in;
        next_state[7] = in;
    end
    if (state[8] | state[9]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
end

endmodule