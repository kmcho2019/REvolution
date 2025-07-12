module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A,..., y[5]=F
    input        w,
    output       Y1,  // Next-state bit for B (y[1])
    output       Y3   // Next-state bit for D (y[3])
);

    // next_y[i] is asserted if any transition leads to state i
    // State encodings:
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // next_y[0] = A next: from A if w=1, from D if w=1
    wire next_y0 = (y[0] & w) | (y[3] & w);

    // next_y[1] = B next: from A if w=0
    wire next_y1 = y[0] & ~w;

    // next_y[2] = C next: from B if w=0, from F if w=0
    wire next_y2 = (y[1] & ~w) | (y[5] & ~w);

    // next_y[3] = D next: from B if w=1, C if w=1, E if w=1, F if w=1
    wire next_y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

    // next_y[4] = E next: from C if w=0, from E if w=0
    wire next_y4 = (y[2] & ~w) | (y[4] & ~w);

    // next_y[5] = F next: from D if w=0
    wire next_y5 = y[3] & ~w;

    assign Y1 = next_y1;
    assign Y3 = next_y3;

endmodule