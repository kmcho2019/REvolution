module TopModule (
    input  [5:0] y,   // one-hot current states: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state B (y[1])
    output       Y4   // next state D (y[3])
);

    // Next state signals for all states (A to F) are computed based on current y and input w
    wire nsA, nsB, nsC, nsD, nsE, nsF;

    // From state A (y[0]):
    // if w=0 -> next B (y[1])
    // if w=1 -> next A (y[0])
    assign nsA = y[0] & w;
    assign nsB = y[0] & ~w;

    // From state B (y[1]):
    // if w=0 -> next C (y[2])
    // if w=1 -> next D (y[3])
    assign nsC = y[1] & ~w;
    assign nsD = y[1] & w;

    // From state C (y[2]):
    // if w=0 -> next E (y[4])
    // if w=1 -> next D (y[3])
    assign nsE = y[2] & ~w;
    assign nsD = nsD | (y[2] & w);  // OR with previous nsD

    // From state D (y[3]):
    // if w=0 -> next F (y[5])
    // if w=1 -> next A (y[0])
    assign nsF = y[3] & ~w;
    assign nsA = nsA | (y[3] & w);

    // From state E (y[4]):
    // if w=0 -> next E (y[4])
    // if w=1 -> next D (y[3])
    assign nsE = nsE | (y[4] & ~w);
    assign nsD = nsD | (y[4] & w);

    // From state F (y[5]):
    // if w=0 -> next C (y[2])
    // if w=1 -> next D (y[3])
    assign nsC = nsC | (y[5] & ~w);
    assign nsD = nsD | (y[5] & w);

    // Outputs: next B and next D states
    assign Y2 = nsB;
    assign Y4 = nsD;

endmodule