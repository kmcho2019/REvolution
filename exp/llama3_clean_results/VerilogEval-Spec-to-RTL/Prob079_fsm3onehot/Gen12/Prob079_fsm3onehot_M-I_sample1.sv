module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // State transition logic
    assign next_state = (
        (state == A && !in) ? A :
        (state == A &&  in) ? B :
        (state == B && !in) ? C :
        (state == B &&  in) ? B :
        (state == C && !in) ? A :
        (state == C &&  in) ? D :
        (state == D && !in) ? C :
        (state == D &&  in) ? B : 4'bxxxx
    );

    // Output logic
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule