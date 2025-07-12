module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Current state bits as one-hot signals
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state conditions by input and current state
    wire nextA = (A & ~in) | (C & ~in);
    wire nextB = (A & in) | (B & in) | (D & in);
    wire nextC = (B & ~in) | (D & ~in);
    wire nextD = C & in;

    // Combine into next_state vector
    assign next_state = {nextD, nextC, nextB, nextA};

    // Output is high only in state D
    assign out = D;

endmodule