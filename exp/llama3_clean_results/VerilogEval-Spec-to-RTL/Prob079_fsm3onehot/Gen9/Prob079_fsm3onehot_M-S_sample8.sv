module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding as parameters
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State transition logic using case statement
    assign next_state = (
        (state == A)? (in? B : A) :
        (state == B)? (in? B : C) :
        (state == C)? (in? D : A) :
        (state == D)? (in? B : C) :
        4'bxxxx
    );

    // Simplified output logic
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule