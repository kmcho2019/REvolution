module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding
    // A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    // Next state logic (combinational)
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);            // A next state bit: A if in=0 and state A, or A if in=0 and state C
    assign next_state[1] = (state[0] & in)  | (state[1] & in) | (state[3] & in); // B next state bit: B if in=1 and state A, or B if in=1 and state B, or B if in=1 and state D
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);           // C next state bit: C if in=0 and state B, or C if in=0 and state D
    assign next_state[3] =  state[2] & in;                               // D next state bit: D if in=1 and state C

    // Output logic (Moore output, depends only on current state)
    assign out = state[3]; // output=1 only in state D

endmodule