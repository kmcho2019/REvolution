module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for reference:
    // A=00, B=01, C=10, D=11

    // Next state logic implemented as combinational assignments:
    // next_state[1]:
    // - For A(00): next_state = A(00) if in=0, B(01) if in=1 => next_state[1] = 0
    // - For B(01): next_state = C(10) if in=0, B(01) if in=1 => next_state[1] = ~in
    // - For C(10): next_state = A(00) if in=0, D(11) if in=1 => next_state[1] = in
    // - For D(11): next_state = C(10) if in=0, B(01) if in=1 => next_state[1] = ~in
    // Thus, next_state[1] = (~state[1] & state[0] & ~in) | (state[1] & ~state[0] & in) | (state[1] & state[0] & ~in)

    // next_state[0]:
    // - For A(00): next_state = A(00) if in=0, B(01) if in=1 => next_state[0] = in
    // - For B(01): next_state = C(10) if in=0, B(01) if in=1 => next_state[0] = 0
    // - For C(10): next_state = A(00) if in=0, D(11) if in=1 => next_state[0] = in
    // - For D(11): next_state = C(10) if in=0, B(01) if in=1 => next_state[0] = state[1] & ~in

    // Compose next_state bits from above logic

    wire next_state1 = (~state[1] &  state[0] & ~in) | 
                       ( state[1] & ~state[0] &  in) | 
                       ( state[1] &  state[0] & ~in);

    wire next_state0 = ( ~state[1] & ~state[0] &  in) | 
                       (~state[1] &  state[0] &  1'b0) | // zero term omitted
                       ( state[1] & ~state[0] &  1'b0) | // zero term omitted
                       ( state[1] &  state[0] & ~in) | 
                       (~state[1] & ~state[0] &  1'b0);  // zero term omitted

    // Simplify next_state0:
    // next_state0 = (state==A and in) or (state==D and ~in)
    // => next_state0 = (~state[1] & ~state[0] & in) | (state[1] & state[0] & ~in)

    assign next_state = {next_state1, next_state0};

    // Moore output: out=1 only in state D(11)
    assign out = state[1] & state[0];

endmodule