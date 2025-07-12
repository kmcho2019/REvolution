module TopModule(
    input       in,
    input [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    // Decode current state bits for clarity
    wire s1 = state[1];
    wire s0 = state[0];

    // next_state[1] logic:
    // next_state = function of (state, in)
    // From the table:
    // A=00 -> next_state = 00 if in=0 else 01
    // B=01 -> next_state = 10 if in=0 else 01
    // C=10 -> next_state = 00 if in=0 else 11
    // D=11 -> next_state = 10 if in=0 else 01

    // Break down next_state bits:

    // next_state[1] = (state == B and in==0) or (state == C and in==1) or (state == D and in==0)
    // Encoding those conditions:

    wire isA = ~s1 & ~s0;
    wire isB = ~s1 &  s0;
    wire isC =  s1 & ~s0;
    wire isD =  s1 &  s0;

    // next_state[1]
    wire ns1 = (isB & ~in) | (isC & in) | (isD & ~in);

    // next_state[0] = (state == A and in==1) or (state == B and in==1) or (state == D and in==1)
    // According to table:
    // A->next_state: 0->A(00), 1->B(01)
    // B->next_state: 0->C(10), 1->B(01)
    // C->next_state: 0->A(00), 1->D(11)
    // D->next_state: 0->C(10), 1->B(01)
    //
    // next_state[0] is 1 for next_state = B(01) or D(11)
    // So next_state[0] is 1 when next_state is B or D, i.e. when next_state is 01 or 11
    // For input conditions:
    // A(00) and in=1 => next_state=01, so next_state[0]=1
    // B(01) and in=1 => next_state=01, next_state[0]=1
    // C(10) and in=1 => next_state=11, next_state[0]=1
    // D(11) and in=1 => next_state=01, next_state[0]=1
    // For in=0, next_state[0]=0

    wire ns0 = in & (isA | isB | isC | isD); // simply in and any state

    // Output is function of state only (Moore machine output)
    // From table, output=1 only in state D

    assign out = isD;

    assign next_state = {ns1, ns0};

endmodule