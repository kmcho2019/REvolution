module TopModule(
    input  in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
// Output is 1 only when the current state is D, otherwise it's 0
assign out = state[3]; // D state bit is at position 3 (MSB)

// State transition logic
// Next state when in=0
wire next_state_in0_A = state[0]; // Stay in A
wire next_state_in0_B = state[1]; // Move to C from B
wire next_state_in0_C = state[2]; // Move to A from C
wire next_state_in0_D = state[2]; // Move to C from D

// Next state when in=1
wire next_state_in1_A = state[1]; // Move to B from A
wire next_state_in1_B = state[1]; // Stay in B
wire next_state_in1_C = state[3]; // Move to D from C
wire next_state_in1_D = state[1]; // Move to B from D

// Combine next state logic based on input
assign next_state[0] = (~in & next_state_in0_A) | (in & next_state_in1_A); // A bit
assign next_state[1] = (~in & next_state_in0_B) | (in & next_state_in1_B); // B bit
assign next_state[2] = (~in & next_state_in0_C) | (in & next_state_in1_C); // C bit
assign next_state[3] = (~in & next_state_in0_D) | (in & next_state_in1_D); // D bit

endmodule