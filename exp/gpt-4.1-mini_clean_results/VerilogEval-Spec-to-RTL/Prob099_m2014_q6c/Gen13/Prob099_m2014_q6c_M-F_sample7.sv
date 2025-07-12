module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

    // Define symbolic names for readability
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Compute next state one-hot vector (6 bits)
    // For each state next bit, sum all transitions entering that state.

    wire [5:0] next_state;

    // Next A (y[0]):
    // From A (w=1) -> A
    // From D (w=1) -> A
    assign next_state[0] = (A & w) | (D & w);

    // Next B (y[1]):
    // From A (w=0) -> B
    assign next_state[1] = A & ~w;

    // Next C (y[2]):
    // From B (w=0) -> C
    // From F (w=0) -> C
    assign next_state[2] = (B & ~w) | (F & ~w);

    // Next D (y[3]):
    // From B (w=1) -> D
    // From C (w=1) -> D
    // From D (w=1) -> D
    // From E (w=1) -> D
    // From F (w=1) -> D
    assign next_state[3] = w & (B | C | D | E | F);

    // Next E (y[4]):
    // From C (w=0) -> E
    // From E (w=0) -> E
    assign next_state[4] = (C & ~w) | (E & ~w);

    // Next F (y[5]):
    // From D (w=0) -> F
    assign next_state[5] = D & ~w;

    // Assign outputs Y1 and Y3 from next_state bits for B and D
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule