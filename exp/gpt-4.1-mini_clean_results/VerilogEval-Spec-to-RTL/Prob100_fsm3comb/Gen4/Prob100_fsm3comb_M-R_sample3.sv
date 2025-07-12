module TopModule(
    input       in,
    input [1:0] state,
    output [1:0] next_state,
    output       out
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state logic: multiplexer on state and input
    assign next_state =
        (state == A) ? (in ? B : A) :
        (state == B) ? (in ? B : C) :
        (state == C) ? (in ? D : A) :
        (state == D) ? (in ? B : C) :
        A; // default to A on invalid state

    // Output logic depends only on state (Moore machine)
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule