module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Next-state signal Y2 (y[1]) is 1 when the current state is A (y[0] = 1) and w = 0
    // or when the current state is B (y[1] = 1) and w = 1
    assign Y1 = (y[0] & ~w) | (y[1] & w);

    // Next-state signal Y4 (y[3]) is 1 when the current state is B (y[1] = 1) and w = 1
    // or when the current state is C (y[2] = 1) and w = 1
    // or when the current state is E (y[4] = 1) and w = 1
    // or when the current state is D (y[3] = 1) and w = 1
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[3] & w);

endmodule