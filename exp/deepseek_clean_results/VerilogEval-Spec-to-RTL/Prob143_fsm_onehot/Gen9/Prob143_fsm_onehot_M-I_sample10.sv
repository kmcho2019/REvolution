module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic
assign out1 = |state[9:8];  // OR reduction for states 8 and 9
assign out2 = |state[9:7];  // OR reduction for states 7 and 9

always @(*) begin
    next_state = 10'b0;
    
    // Factor out common ~in for next_state[0]
    next_state[0] = (|state[9:0] & ~in) & ~(|state[6:5] & ~in);  // All states except 5,6 when ~in
    
    // Optimized next state calculations
    next_state[1] = |{state[0], state[8], state[9]} & in;
    next_state[2] = state[1] & in;
    next_state[3] = state[2] & in;
    next_state[4] = state[3] & in;
    next_state[5] = state[4] & in;
    next_state[6] = state[5] & in;
    next_state[7] = state[6] & in | state[7] & in;
    next_state[8] = state[5] & ~in;
    next_state[9] = state[6] & ~in;
    
    // Handle S5 and S6 special cases for next_state[0]
    next_state[0] = next_state[0] | (state[5] & ~in) | (state[6] & ~in);
end

endmodule