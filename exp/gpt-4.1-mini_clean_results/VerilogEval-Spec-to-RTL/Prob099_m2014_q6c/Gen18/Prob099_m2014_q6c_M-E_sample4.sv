module TopModule (
    input  [5:0] y,  // Current state one-hot: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y1, // Next state's B bit (y[1])
    output       Y3  // Next state's D bit (y[3])
);

    // Decode current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Compute next state bits (one-hot encoding) based on FSM transition table and input w:

    // Next A (y[0]) is active when:
    // - From A on w=1 --> A
    // - From D on w=1 --> A
    wire nextA = (A & w) | (D & w);

    // Next B (y[1]) is active when:
    // - From A on w=0 --> B
    wire nextB = (A & ~w);

    // Next C (y[2]) is active when:
    // - From B on w=0 --> C
    // - From F on w=0 --> C
    wire nextC = (B & ~w) | (F & ~w);

    // Next D (y[3]) is active when:
    // - From B on w=1 --> D
    // - From C on w=1 --> D
    // - From D on w=1 --> D
    // - From E on w=1 --> D
    // - From F on w=1 --> D
    wire nextD = w & (B | C | D | E | F);

    // Next E (y[4]) is active when:
    // - From C on w=0 --> E
    // - From E on w=0 --> E
    wire nextE = (C & ~w) | (E & ~w);

    // Next F (y[5]) is active when:
    // - From D on w=0 --> F
    wire nextF = D & ~w;

    // Now assign outputs for next state's bits corresponding to B and D:
    assign Y1 = nextB;
    assign Y3 = nextD;

endmodule