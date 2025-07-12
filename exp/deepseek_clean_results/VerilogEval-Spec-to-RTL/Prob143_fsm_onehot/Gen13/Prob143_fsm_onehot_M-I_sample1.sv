module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic using bitwise OR
assign {out1, out2} = (state[8] | state[9]) ? {1'b1, state[9]} : 
                      (state[7])             ? {1'b0, 1'b1}     : 
                                              {1'b0, 1'b0};

// Precompute common signals
wire in_n = ~in;
wire [3:0] s1_s4_in = state[4:1] & {4{in}};

always @(*) begin
    // Default next_state to S0 transition (most common case)
    next_state = {10{in_n}} & {10{state != 10'b0}};
    
    // Handle S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Optimized S1-S4 transitions using vector operations
    if (|state[4:1]) begin
        next_state[2:5] = {s1_s4_in[3], s1_s4_in[2], s1_s4_in[1], s1_s4_in[0]};
    end
    
    // Handle S5 and S6 transitions
    next_state[8] = (state[5] & in_n) | next_state[8];
    next_state[6] = state[5] & in;
    next_state[9] = (state[6] & in_n) | next_state[9];
    next_state[7] = state[6] & in;
    
    // Handle S7 self-loop
    next_state[7] = (state[7] & in) | next_state[7];
    
    // Optimized S8 and S9 transitions
    if (|state[9:8]) begin
        next_state[1] = next_state[1] | in;
    end
end

endmodule