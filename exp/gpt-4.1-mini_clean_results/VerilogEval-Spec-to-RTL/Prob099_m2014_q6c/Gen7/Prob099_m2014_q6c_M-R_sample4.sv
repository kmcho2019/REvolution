module TopModule(
    input  [5:0] y,   // current one-hot state
    input        w,
    output       Y2,  // next-state bit corresponding to y[1] (B)
    output       Y4   // next-state bit corresponding to y[3] (D)
);

    // Decode current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next-state one-hot signals computed from the state machine and input w
    // From state A:
    // A --0--> B, A --1--> A
    wire nextA_from_A = A & w;
    wire nextB_from_A = A & ~w;

    // From state B:
    // B --0--> C, B --1--> D
    wire nextC_from_B = B & ~w;
    wire nextD_from_B = B & w;

    // From state C:
    // C --0--> E, C --1--> D
    wire nextE_from_C = C & ~w;
    wire nextD_from_C = C & w;

    // From state D:
    // D --0--> F, D --1--> A
    wire nextF_from_D = D & ~w;
    wire nextA_from_D = D & w;

    // From state E:
    // E --0--> E, E --1--> D
    wire nextE_from_E = E & ~w;
    wire nextD_from_E = E & w;

    // From state F:
    // F --0--> C, F --1--> D
    wire nextC_from_F = F & ~w;
    wire nextD_from_F = F & w;

    // Combine all contributions for each next state
    wire nextA = nextA_from_A | nextA_from_D;
    wire nextB = nextB_from_A;
    wire nextC = nextC_from_B | nextC_from_F;
    wire nextD = nextD_from_B | nextD_from_C | nextD_from_E | nextD_from_F;
    wire nextE = nextE_from_C | nextE_from_E;
    wire nextF = nextF_from_D;

    // Outputs: next-state bits for y[1] (B) and y[3] (D)
    assign Y2 = nextB;
    assign Y4 = nextD;

endmodule