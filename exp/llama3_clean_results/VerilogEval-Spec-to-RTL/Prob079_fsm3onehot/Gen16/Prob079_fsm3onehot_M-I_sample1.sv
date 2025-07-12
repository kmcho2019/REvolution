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
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A or C to A
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in) | (state[3] & ~in & ~state[2]); // A, B, or D to B
    assign next_state[2] = (state[1] & ~in); // B to C
    assign next_state[3] = (state[2] & in); // C to D

    // Output logic using one-hot state encoding property
    assign out = state[3];

endmodule