module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Decode current state bits
    wire s0 = state[0];
    wire s1 = state[1];

    // next_state[1] logic:
    // From state table:
    // next_state[1] = 1 when:
    // - state A (00), in=1 -> next_state=B(01) => bit1=0
    // - state B (01), in=0 -> next_state=C(10) => bit1=1
    // - state B (01), in=1 -> next_state=B(01) => bit1=0
    // - state C (10), in=0 -> next_state=A(00) => bit1=0
    // - state C (10), in=1 -> next_state=D(11) => bit1=1
    // - state D (11), in=0 -> next_state=C(10) => bit1=1
    // - state D (11), in=1 -> next_state=B(01) => bit1=0
    //
    // Summarize:
    // next_state[1] = (state==B && in==0) || (state==C && in==1) || (state==D && in==0)
    wire state_is_B = (~s1) & s0;
    wire state_is_C = s1 & (~s0);
    wire state_is_D = s1 & s0;

    wire ns1 = (state_is_B & ~in) | (state_is_C & in) | (state_is_D & ~in);

    // next_state[0] logic:
    // From table:
    // next_state[0] = 1 when:
    // - A(00), in=1 -> B(01) => bit0=1
    // - B(01), in=1 -> B(01) => bit0=1
    // - C(10), in=1 -> D(11) => bit0=1
    // - D(11), in=1 -> B(01) => bit0=1
    // Others:
    // - A(00), in=0 -> A(00) => 0
    // - B(01), in=0 -> C(10) => 0
    // - C(10), in=0 -> A(00) => 0
    // - D(11), in=0 -> C(10) => 0
    //
    // So next_state[0] = 1 when in==1 and (state != C(10) with in=1? No, in all states with in=1 except maybe C - C in=1 next_state=11 bit0=1)
    // Actually, next_state[0] = in & (state==A | state==B | state==C | state==D) with output bit0=1
    // But carefully:
    // For in=1, next_state[0] = 1 always.
    // For in=0, next_state[0] = 0 always.
    //
    // So simply next_state[0] = in.

    wire ns0 = in;

    // Output logic: out=1 only for state D(11)
    assign out = (state == 2'b11);

    assign next_state = {ns1, ns0};

endmodule