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

    // Output logic
    assign out = (state == D) ? 1'b1 : 1'b0;

    // State transition logic using conditionals
    assign next_state = (in == 0) ? (
        (state == A) ? A :
        (state == B) ? C :
        (state == C) ? A :
        (state == D) ? C : 4'bxxxx
    ) : (
        (state == A) ? B :
        (state == B) ? B :
        (state == C) ? D :
        (state == D) ? B : 4'bxxxx
    );

endmodule