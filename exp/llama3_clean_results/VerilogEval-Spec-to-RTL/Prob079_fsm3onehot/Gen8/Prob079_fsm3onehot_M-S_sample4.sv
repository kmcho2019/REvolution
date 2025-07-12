module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic
    assign next_state[0] = (~in & A) | (~in & C);
    assign next_state[1] = (in & A) | (~in & B) | (in & D);
    assign next_state[2] = (~in & B);
    assign next_state[3] = (in & C);

    // Output logic
    assign out = D;

endmodule