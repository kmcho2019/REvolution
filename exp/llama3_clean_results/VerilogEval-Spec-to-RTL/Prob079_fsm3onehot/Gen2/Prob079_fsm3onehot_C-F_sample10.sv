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

    // State transition logic using case statement within continuous assignment
    assign next_state = (
        (state == A)? (in? B : A) :
        (state == B)? (in? B : C) :
        (state == C)? (in? D : A) :
        (state == D)? (in? B : C) :
        A // Default state, sets next_state to A if state is not recognized
    );

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule