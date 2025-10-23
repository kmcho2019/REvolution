module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Next-state signal Y1 (corresponding to y[1])
    // Y1 is set when:
    // - current state is A and w is 1
    // - current state is C and w is 0
    // - current state is E and w is 0
    assign Y1 = (y[0] && w) || (y[2] && ~w) || (y[4] && ~w);

    // Next-state signal Y3 (corresponding to y[3])
    // Y3 is set when:
    // - current state is B and w is 1
    // - current state is C and w is 1
    // - current state is D and w is 1
    // - current state is E and w is 1
    // - current state is F and w is 1
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w) || (y[5] && w);
endmodule