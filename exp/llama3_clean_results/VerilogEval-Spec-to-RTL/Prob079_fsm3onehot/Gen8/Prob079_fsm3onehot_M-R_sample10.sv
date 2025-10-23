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

    // State transition logic using case statement
    assign next_state = (
        (state == A &&!in)? A :
        (state == A && in) ? B :
        (state == B &&!in)? C :
        (state == B && in) ? B :
        (state == C &&!in)? A :
        (state == C && in) ? D :
        (state == D &&!in)? C :
        (state == D && in) ? B : 4'bxxxx
    );

    // Alternatively, using a case statement within an assign block
    // assign next_state = (case ({state, in})
    //     {A, 1'b0}: A,
    //     {A, 1'b1}: B,
    //     {B, 1'b0}: C,
    //     {B, 1'b1}: B,
    //     {C, 1'b0}: A,
    //     {C, 1'b1}: D,
    //     {D, 1'b0}: C,
    //     {D, 1'b1}: B,
    //     default: 4'bxxxx
    // endcase);

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule