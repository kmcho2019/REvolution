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

    // Define next state based on input condition
    assign next_state = (in)?
        ((state == A)? B :
         (state == B)? B :
         (state == C)? D :
         (state == D)? B : 4'bxxxx) :
        ((state == A)? A :
         (state == B)? C :
         (state == C)? A :
         (state == D)? C : 4'bxxxx);

    // Output logic using one-hot state encoding property
    assign out = (state[3])? 1'b1 : 1'b0;

endmodule