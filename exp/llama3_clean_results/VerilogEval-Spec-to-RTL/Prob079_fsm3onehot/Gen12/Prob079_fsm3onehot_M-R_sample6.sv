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

    // State transition logic
    assign next_state = (state == A && !in) ? A :
                        (state == A && in)  ? B :
                        (state == B && !in) ? C :
                        (state == B && in)  ? B :
                        (state == C && !in) ? A :
                        (state == C && in)  ? D :
                        (state == D && !in) ? C :
                        (state == D && in)  ? B : 4'bxxxx;

    // Output logic
    assign out = (state == D);

endmodule