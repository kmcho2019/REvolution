module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Since we are using one-hot encoding, we can directly use the bits of y to represent the states.
    // For Y1 (state A), it is 1 when the current state is D (001000) and w is 1.
    assign Y1 = y[3] & w;

    // For Y3 (state D), it is 1 when the current state is B (000010) or C (000100) or E (010000) or F (100000) and w is 1.
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);
endmodule