module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding (for reference)
    // A=00, B=01, C=10, D=11

    // next_state[1]: 
    // From table:
    // A=00 -> next_state = A(00) if in=0 else B(01) => next_state[1]=0 either way for A
    // B=01 -> next_state = C(10) if in=0 else B(01) => next_state[1]=in?0:1=~in; but must verify carefully
    // C=10 -> next_state = A(00) if in=0 else D(11) => next_state[1]=in?1:0 = in
    // D=11 -> next_state = C(10) if in=0 else B(01) => next_state[1]=in?0:1=~in

    // Let's rewrite next_state[1]:
    // next_state[1] = (~state[1] & state[0] & ~in)  // B & in=0 -> next_state= C(10), next_state[1]=1
    //               | (state[1] & ~state[0] & in)   // C & in=1 -> next_state= D(11), next_state[1]=1
    // For other cases next_state[1]=0

    assign next_state[1] = (~state[1] & state[0] & ~in) | (state[1] & ~state[0] & in);

    // next_state[0]:
    // From table:
    // A=00 -> next_state = A(00) if in=0 else B(01) => next_state[0] = in & 1
    // B=01 -> next_state = C(10) if in=0 else B(01) => next_state[0] = 0 if in=0 else 1
    // C=10 -> next_state = A(00) if in=0 else D(11) => next_state[0] = 0 always
    // D=11 -> next_state = C(10) if in=0 else B(01) => next_state[0] = 0 if in=0 else 1

    // Simplify next_state[0]:
    // next_state[0] = (~state[1] & ~state[0] & in)            // A & in=1 -> B(01), next_state[0]=1
    //               | (~state[1] & state[0] & in)             // B & in=1 -> B(01), next_state[0]=1
    //               | (state[1] & state[0] & in)              // D & in=1 -> B(01), next_state[0]=1
    // Otherwise 0

    assign next_state[0] = in & ((~state[1] & ~state[0]) | (~state[1] & state[0]) | (state[1] & state[0]));

    // Output is 1 only in state D = 11
    assign out = state[1] & state[0];

endmodule