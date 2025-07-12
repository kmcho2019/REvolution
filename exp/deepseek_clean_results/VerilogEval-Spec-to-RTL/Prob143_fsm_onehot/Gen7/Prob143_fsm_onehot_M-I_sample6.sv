module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic - shared computation for state[9]
wire s8_or_s9 = state[8] | state[9];
assign out1 = s8_or_s9;
assign out2 = state[7] | s8_or_s9;

// Precompute common signals
wire in_n = ~in;
wire any_s1_s4 = |state[4:1];
wire any_s8_s9 = |state[9:8];

always @(*) begin
    // Initialize next_state to 0
    next_state = 10'b0;
    
    // Handle S0-S4 transitions (common pattern)
    if (state[0] | any_s1_s4) begin
        next_state[0] = in_n;
        if (state[0]) next_state[1] = in;
        if (any_s1_s4) begin
            next_state[{state[4], state[3], state[2], state[1], 1'b0} + 2] = in;
        end
    end
    
    // Handle S5-S6 transitions (similar pattern)
    if (state[5] | state[6]) begin
        next_state[{state[6], 3'b0} + 8] = in_n;
        next_state[{state[5], 1'b0} + 6] = in;
    end
    
    // Handle S7-S9 transitions
    if (state[7] | any_s8_s9) begin
        next_state[0] = next_state[0] | in_n;
        if (state[7]) next_state[7] = in;
        if (any_s8_s9) next_state[1] = next_state[1] | in;
    end
end

endmodule