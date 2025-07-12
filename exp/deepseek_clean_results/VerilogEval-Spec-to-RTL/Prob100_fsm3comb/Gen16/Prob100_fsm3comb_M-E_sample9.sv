module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// LUT-based state transition
// Encoding: [state][in] -> next_state
// Format: {next_state_D, next_state_C, next_state_B, next_state_A}
// Each state is 2 bits, organized as:
// {D_in1, D_in0, C_in1, C_in0, B_in1, B_in0, A_in1, A_in0}
parameter [7:0] STATE_LUT = 8'b01_00_01_01_10_00_01_00;

always @(*) begin
    // Calculate next state using LUT
    next_state = STATE_LUT[{state, in}*2 +: 2];
    
    // Output is high only when in state D (2'b11)
    out = &state;  // AND reduction of state bits (true only for 2'b11)
end

endmodule