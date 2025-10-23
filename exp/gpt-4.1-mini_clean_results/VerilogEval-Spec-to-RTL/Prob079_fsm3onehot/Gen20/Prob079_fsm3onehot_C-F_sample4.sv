module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state decoding: A=state[0], B=state[1], C=state[2], D=state[3]
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Inverted input buffered for reuse
    wire in_n = ~in;

    // Moore FSM next state logic (one-hot encoded):
    // State transitions based on input 'in':
    // A: next_state = A if in=0 else B
    // B: next_state = C if in=0 else B
    // C: next_state = A if in=0 else D
    // D: next_state = C if in=0 else B
    assign next_state[0] = (A & in_n) | (C & in_n);      // Next state A
    assign next_state[1] = (A & in)   | (B & in)   | (D & in); // Next state B
    assign next_state[2] = (B & in_n) | (D & in_n);      // Next state C
    assign next_state[3] = C & in;                         // Next state D

    // Moore machine output: output '1' only in state D
    assign out = D;

endmodule