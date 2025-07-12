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
    wire [3:0] next_state_in0;
    wire [3:0] next_state_in1;

    assign next_state_in0 = (
        (state == A)? A :
        (state == B)? C :
        (state == C)? A :
        (state == D)? C :
        4'bxxxx
    );

    assign next_state_in1 = (
        (state == A)? B :
        (state == B)? B :
        (state == C)? D :
        (state == D)? B :
        4'bxxxx
    );

    assign next_state = (in)? next_state_in1 : next_state_in0;

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule