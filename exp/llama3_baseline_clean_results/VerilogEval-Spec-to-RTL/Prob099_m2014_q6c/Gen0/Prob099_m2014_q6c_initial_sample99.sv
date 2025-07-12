module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Derive next-state signal Y2 (corresponding to y[1]) by inspection
    // Y2 is 1 when current state is A (y[0] = 1) and w = 1
    assign Y1 = y[0] & w;

    // Derive next-state signal Y4 (corresponding to y[3]) by inspection
    // Y4 is 1 when current state is B (y[1] = 1) and w = 1, or current state is C (y[2] = 1) and w = 1, or current state is E (y[4] = 1) and w = 0
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & ~w);
endmodule