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

    // State transition logic using ternary operators
    assign next_state = 
        (state == A)? (in? B : A) :
        (state == B)? (in? B : C) :
        (state == C)? (in? D : A) :
        (state == D)? (in? B : C) :
        4'bxxxx;

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

    // Alternatively, for better readability or synthesis, the state transition logic could be represented as:
    // assign next_state = (state == A)? {3'b000, in} :
    //                     (state == B)? {in? 3'b001 : 3'b010, 1'b0} :
    //                     (state == C)? {in? 3'b100 : 3'b000, 1'b0} :
    //                     (state == D)? {in? 3'b001 : 3'b010, 1'b0} :
    //                     4'bxxxx;

endmodule