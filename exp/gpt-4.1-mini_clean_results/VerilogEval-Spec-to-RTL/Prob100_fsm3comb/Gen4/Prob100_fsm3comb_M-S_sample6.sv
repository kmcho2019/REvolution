module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Output is 1 only in state D (2'b11)
    assign out = &state;

    // next_state[1] = state transitions to 1 when:
    // From table: next_state[1] = (state == B && in==0) or (state == D && in==0) or (state == C && in==1)
    // Encode using logic:
    // state bits: state[1], state[0]
    // Conditions:
    // B = 01 -> state[1]=0,state[0]=1
    // D = 11 -> state[1]=1,state[0]=1
    // C = 10 -> state[1]=1,state[0]=0
    // So next_state[1] = (~state[1]&state[0]&~in) | (state[1]&state[0]&~in) | (state[1]&~state[0]&in)
    assign next_state[1] = (~state[1] & state[0] & ~in) | (state[1] & state[0] & ~in) | (state[1] & ~state[0] & in);

    // next_state[0] = state transitions to 1 when:
    // From table: next_state[0] = (state == A && in==1) or (state == B && in==1) or (state == D && in==1)
    // Using states A=00, B=01, D=11
    // next_state[0] = (~state[1]&~state[0]&in) | (~state[1]&state[0]&in) | (state[1]&state[0]&in)
    assign next_state[0] = in & ((~state[1]&~state[0]) | (~state[1]&state[0]) | (state[1]&state[0]));

endmodule