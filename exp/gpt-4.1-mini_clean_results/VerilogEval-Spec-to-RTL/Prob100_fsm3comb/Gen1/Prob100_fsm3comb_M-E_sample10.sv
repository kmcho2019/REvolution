module TopModule(
    input  wire       in,
    input  wire [1:0] state,
    output wire [1:0] next_state,
    output wire       out
);

    // Define next_state lookup table indexed by {state, in}
    // Order: {state,in} -> next_state
    // States: A=00, B=01, C=10, D=11
    // next_state table from problem statement:
    // A(00): in=0->A(00), in=1->B(01)
    // B(01): in=0->C(10), in=1->B(01)
    // C(10): in=0->A(00), in=1->D(11)
    // D(11): in=0->C(10), in=1->B(01)
    localparam [7:0][1:0] NEXT_STATES = {
        2'b01, // state=11, in=1 : B
        2'b10, // state=11, in=0 : C
        2'b11, // state=10, in=1 : D
        2'b00, // state=10, in=0 : A
        2'b01, // state=01, in=1 : B
        2'b10, // state=01, in=0 : C
        2'b01, // state=00, in=1 : B
        2'b00  // state=00, in=0 : A
    };

    wire [2:0] addr = {state, in};
    assign next_state = NEXT_STATES[addr];

    // Moore output depends only on state; output=1 if state==D(11), else 0
    assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule