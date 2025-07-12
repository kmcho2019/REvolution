module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic
assign out1 = |state[9:8];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Precompute common signals
wire in_n = ~in;
wire [9:0] state_n = ~state;  // For potential use in future optimizations

always @(*) begin
    // Initialize next_state to 0
    next_state = 10'b0;
    
    // Handle S0 transition
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Group S1-S5 which share similar transition patterns (to S0 on 0, increment on 1)
    wire [4:0] s1_s5 = state[5:1];
    if (|s1_s5) begin
        next_state[0] = next_state[0] | in_n;
        if (s1_s5[0]) next_state[2] = in;
        if (s1_s5[1]) next_state[3] = in;
        if (s1_s5[2]) next_state[4] = in;
        if (s1_s5[3]) next_state[5] = in;
        if (s1_s5[4]) next_state[in ? 6 : 8] = 1'b1;  // Combined S5 transition
    end
    
    // Handle S6 transition (similar to S5 but different next states)
    if (state[6]) begin
        next_state[in ? 7 : 9] = 1'b1;
    end
    
    // Group S7-S9 transitions (all go to S0 on 0, S1/S7 on 1)
    wire [2:0] s7_s9 = state[9:7];
    if (|s7_s9) begin
        next_state[0] = next_state[0] | in_n;
        if (s7_s9[0]) next_state[7] = in;  // S7 stays on 1
        if (s7_s9[1] | s7_s9[2]) next_state[1] = next_state[1] | in;  // S8/S9 go to S1 on 1
    end
end

endmodule