module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Directly manipulate bits for state transition logic
    assign next_state = (
        (state == A &&  !in) ? A :
        (state == A &&   in) ? B :
        (state == B &&  !in) ? C :
        (state == B &&   in) ? B :
        (state == C &&  !in) ? A :
        (state == C &&   in) ? D :
        (state == D &&  !in) ? C :
        (state == D &&   in) ? B : 4'bxxxx
    );

    // Alternatively, to simplify further with bitwise operations is challenging due to the nature of one-hot encoding and the specific state transitions.
    // Output logic remains straightforward
    assign out = (state == D);

endmodule