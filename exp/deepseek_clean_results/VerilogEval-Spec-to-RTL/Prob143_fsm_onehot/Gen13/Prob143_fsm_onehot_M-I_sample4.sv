module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic - shared OR operation
wire out_common = state[8] | state[9];
assign out1 = out_common;
assign out2 = out_common | state[7];

// Precompute all common signals
wire in_n = ~in;
wire any_S1_S4 = |state[4:1];
wire any_S8_S9 = |state[9:8];
wire any_S5_S6 = |state[6:5];

always @(*) begin
    // Default all bits to 0 (let synthesis optimize)
    next_state = 10'b0;
    
    // S0 transition (handled first as it's most common)
    next_state[0] = (state[0] | any_S1_S4 | state[7] | any_S8_S9) & in_n;
    next_state[1] = (state[0] | any_S8_S9) & in;
    
    // Group S1-S4 transitions
    if (any_S1_S4) begin
        if (state[1]) next_state[2] = in;
        if (state[2]) next_state[3] = in;
        if (state[3]) next_state[4] = in;
        if (state[4]) next_state[5] = in;
    end
    
    // Group S5-S6 transitions
    if (any_S5_S6) begin
        next_state[state[5] ? 8 : 9] = in_n;
        next_state[state[5] ? 6 : 7] = in;
    end
    
    // S7 transition (special case for maintaining state)
    if (state[7]) begin
        next_state[7] = in;
    end
end

endmodule