module TopModule(
    input       in,
    input [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // next_state[1] logic:
    // From table:
    // A(00): next 0 if in=0, 0 if in=1 => next_state[1]=0
    // B(01): next 1 if in=0 (C=10), 0 if in=1 (B=01) => depends on state and in
    // C(10): next 0 if in=0 (A=00), 1 if in=1 (D=11)
    // D(11): next 1 if in=0 (C=10), 0 if in=1 (B=01)
    //
    // After boolean simplification:
    // next_state[1] = (~state[1] & state[0] & ~in) | (state[1] & ~state[0] & in) | (state[1] & state[0] & ~in);
    // which is the same as:
    // next_state[1] = (state == B && in == 0) || (state == C && in == 1) || (state == D && in == 0)
    //
    // next_state[0] logic:
    // Similar analysis:
    // A(00): next 0 if in=0 (A=00), 1 if in=1 (B=01)
    // B(01): next 0 if in=0 (C=10), 1 if in=1 (B=01)
    // C(10): next 0 if in=0 (A=00), 1 if in=1 (D=11)
    // D(11): next 0 if in=0 (C=10), 1 if in=1 (B=01)
    //
    // Simplify next_state[0]:
    // next_state[0] = (state == A && in == 1) ||
    //                 (state == B && in == 1) ||
    //                 (state == C && in == 1) ||
    //                 (state == D && in == 1)
    // or equivalently, whenever in==1 and state is not A(00) only?
    // Observing the table, next_state[0] = in & (state != C(10) & state != D(11)) is not correct
    //
    // Looking more precisely, next_state[0] = (state == A) & in |
    //                                       (state == B) & in |
    //                                       (state == C) & in |
    //                                       (state == D) & in
    // Actually from table, when in=1:
    // A->B(01), B->B(01), C->D(11), D->B(01)
    // So for in=1 next_state[0] is 1 except for C->D(11) next_state[0]=1
    // Actually, next_state[0] = (state != C[1]) & in | when state==C and in==1 next_state=11 so next_state[0]=1
    //
    // Alternatively, next_state[0] = in & ((state == A) | (state == B) | (state == C) | (state == D)) = in
    //
    // When in=0, next_state[0] is:
    // A->A(00), B->C(10), C->A(00), D->C(10)
    // next_state[0] = 0 for A and C, 0 for B and D (since 10 means next_state[0] = 0)
    // So next_state[0] = 0 when in=0 always.
    //
    // Thus next_state[0] = in
    //
    // To confirm:
    // in=0 next_state[0]=0, in=1 next_state[0]=1 always as per table.
    
    assign next_state[1] = (~state[1] & state[0] & ~in) | (state[1] & ~state[0] & in) | (state[1] & state[0] & ~in);
    assign next_state[0] = in;

    assign out = (state == D);

endmodule