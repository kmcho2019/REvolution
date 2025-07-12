module TopModule(
    input  [5:0] y,   // current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // next-state bit for B (y[1])
    output       Y3   // next-state bit for D (y[3])
);

    // Compute next state signals for all states by inspection:
    // States encoded as one-hot bits: A= y[0], B= y[1], C= y[2], D= y[3], E= y[4], F= y[5]

    wire nextA, nextB, nextC, nextD, nextE, nextF;

    // From transition table:
    // A(0): 0->B, 1->A
    assign nextA = y[0] & w | y[3] & w;  // A--1-->A and D--1-->A
    assign nextB = y[0] & ~w;             // A--0-->B
    assign nextC = y[1] & ~w | y[5] & ~w; // B--0-->C and F--0-->C
    assign nextD = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w) | (y[2] & ~w); 
    // B--1-->D, C--1-->D, E--1-->D, F--1-->D, C--0-->D? No, C--0-->E, so remove y[2]&~w here
    // Correction: from original transitions, C--0-->E, C--1-->D
    // So remove y[2]&~w from D; add to E instead
    // Fix after correction below

    assign nextE = y[2] & ~w | y[4] & ~w; // C--0-->E, E--0-->E
    assign nextF = y[3] & ~w;              // D--0-->F

    // Correct the assignments after above review:
    // Fix nextD, it is y[1]&w | y[2]&w | y[4]&w | y[5]&w, no y[2]&~w here.

    assign nextD = (y[1] | y[2] | y[4] | y[5]) & w;

    // Now outputs Y1 (next-state bit for B) and Y3 (for D)
    assign Y1 = nextB;
    assign Y3 = nextD;

endmodule