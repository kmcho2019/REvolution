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

    // State transition logic using bitwise operations
    assign next_state = (
        (state == A) ? (in ? (A << 1) : A) :
        (state == B) ? (in ? B : (B << 1)) :
        (state == C) ? (in ? (C >> 1) : A) :
        (state == D) ? (in ? B : (C >> 1)) :
        4'bxxxx
    );

    // Output logic using bitwise AND
    assign out = (state & D) != 0;

endmodule