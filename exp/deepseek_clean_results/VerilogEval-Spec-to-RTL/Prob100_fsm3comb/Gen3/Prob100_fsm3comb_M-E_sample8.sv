module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Decode current state
wire is_A = ~state[1] & ~state[0];
wire is_B = ~state[1] &  state[0];
wire is_C =  state[1] & ~state[0];
wire is_D =  state[1] &  state[0];

// Next state bit 1 logic
wire next_state1_case0 = is_B | is_D;  // Next state[1] when in=0
wire next_state1_case1 = is_B | is_D;  // Next state[1] when in=1
assign next_state[1] = in ? next_state1_case1 : next_state1_case0;

// Next state bit 0 logic
wire next_state0_case0 = is_C;         // Next state[0] when in=0
wire next_state0_case1 = is_A | is_B;  // Next state[0] when in=1
assign next_state[0] = in ? next_state0_case1 : next_state0_case0;

// Output is 1 only in state D
assign out = is_D;

endmodule