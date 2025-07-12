module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    wire s0 = state[0];
    wire s1 = state[1];

    // Output logic: out = 1 only in state D (2'b11) => s1 & s0
    assign out = s1 & s0;

    // Next state bit 0 logic (next_state[0]):
    // From table:
    // state A (00): next_state = 00 if in=0 else 01 => next_state[0] = in & 1 = in
    // state B (01): next_state = 10 if in=0 else 01 => next_state[0] = 0 if in=1 else 0 => complex, derive full equation below
    // Let's write full truth table for next_state[0]:

    // State (s1 s0) in next_state
    // 00 in=0 -> 00 => next_state[0]=0
    // 00 in=1 -> 01 => next_state[0]=1
    // 01 in=0 -> 10 => next_state[0]=0
    // 01 in=1 -> 01 => next_state[0]=1
    // 10 in=0 -> 00 => next_state[0]=0
    // 10 in=1 -> 11 => next_state[0]=1
    // 11 in=0 -> 10 => next_state[0]=0
    // 11 in=1 -> 01 => next_state[0]=1

    // Observing next_state[0]:
    // next_state[0]=1 when in=1 regardless of state
    // next_state[0]=0 when in=0 regardless of state
    // So next_state[0] = in

    assign next_state[0] = in;

    // Next state bit 1 logic (next_state[1]):

    // From transition table:
    // State A(00): next_state = A(00) if in=0 else B(01) => next_state[1]=0
    // State B(01): next_state = C(10) if in=0 else B(01) => next_state[1]=1 if in=0 else 0
    // State C(10): next_state = A(00) if in=0 else D(11) => next_state[1]=0 if in=0 else 1
    // State D(11): next_state = C(10) if in=0 else B(01) => next_state[1]=1 if in=0 else 0

    // Create boolean expression:

    // next_state[1] = 1 when:
    // (state=B and in=0) or (state=C and in=1) or (state=D and in=0)

    // Express states:
    // B = 2'b01 => s1=0, s0=1
    // C = 2'b10 => s1=1, s0=0
    // D = 2'b11 => s1=1, s0=1

    // next_state[1] = ( ~s1 & s0 & ~in ) | ( s1 & ~s0 & in ) | ( s1 & s0 & ~in )

    assign next_state[1] = ((~s1) & s0 & ~in) | (s1 & (~s0) & in) | (s1 & s0 & ~in);

endmodule