module TopModule(
    input  [5:0] y,   // current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2,  // next-state bit for B (y[1])
    output       Y4   // next-state bit for D (y[3])
);

    // Next state assignments by inspection of transitions and one-hot states
    // A(0): 0->B(y[1]), 1->A(y[0])
    // B(1): 0->C(y[2]), 1->D(y[3])
    // C(2): 0->E(y[4]), 1->D(y[3])
    // D(3): 0->F(y[5]), 1->A(y[0])
    // E(4): 0->E(y[4]), 1->D(y[3]) (E is a stable state on 0)
    // F(5): 0->C(y[2]), 1->D(y[3])

    wire nextA = (y[0] & w) | (y[3] & w);                // A--1-->A, D--1-->A
    wire nextB = y[0] & ~w;                               // A--0-->B
    wire nextC = (y[1] & ~w) | (y[5] & ~w);              // B--0-->C, F--0-->C
    wire nextD = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w); // B,C,E,F --1--> D
    wire nextE = (y[2] & ~w) | (y[4] & ~w);              // C--0-->E, E--0-->E (stable)
    wire nextF = y[3] & ~w;                               // D--0-->F

    // Output next-state signals for states B (y[1]) and D (y[3])
    assign Y2 = nextB;
    assign Y4 = nextD;

endmodule