module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;
    
    // State transitions
    if (state[0]) begin next_state[0] = ~in; next_state[1] = in; end
    if (state[1]) begin next_state[0] = ~in; next_state[2] = in; end
    if (state[2]) begin next_state[0] = ~in; next_state[3] = in; end
    if (state[3]) begin next_state[0] = ~in; next_state[4] = in; end
    if (state[4]) begin next_state[0] = ~in; next_state[5] = in; end
    if (state[5]) begin next_state[8] = ~in; next_state[6] = in; end
    if (state[6]) begin next_state[9] = ~in; next_state[7] = in; end
    if (state[7]) begin next_state[0] = ~in; next_state[7] = in; end
    if (state[8]) begin next_state[0] = ~in; next_state[1] = in; end
    if (state[9]) begin next_state[0] = ~in; next_state[1] = in; end
end

// Output logic
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |state[9:7:2]; // S7 or S9 (bit 7 and 9)

endmodule