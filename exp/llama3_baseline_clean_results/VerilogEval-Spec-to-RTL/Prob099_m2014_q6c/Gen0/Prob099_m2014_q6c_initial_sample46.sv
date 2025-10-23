module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // One-hot encoding for states
    // A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

    // Next-state logic for Y2 (state B)
    // Set if current state is A and w=1, or C and w=1, or E and w=1, or F and w=1
    assign Y1 = (y[0] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

    // Next-state logic for Y4 (state D)
    // Set if current state is B and w=1, or C and w=1, or E and w=1, or F and w=1
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);
endmodule