module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // next_state[1] (MSB)
    // From table:
    // A->A(00), A->B(01)
    // B->C(10), B->B(01)
    // C->A(00), C->D(11)
    // D->C(10), D->B(01)
    // next_state[1] = (state == B & ~in) | (state == C & in) | (state == D & ~in)
    wire ns1 = (state == B && ~in) || (state == C && in) || (state == D && ~in);

    // next_state[0] (LSB)
    // next_state[0] = (state == A & in) | (state == B) | (state == D & in)
    wire ns0 = (state == A && in) || (state == B) || (state == D && in);

    assign next_state = {ns1, ns0};

    assign out = (state == D);

endmodule