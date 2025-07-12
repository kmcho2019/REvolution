module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Next-state logic for Y2 (state B)
    assign Y2 = (y[0] & w) | (y[2] & w) | (y[4] & ~w) | (y[5] & ~w);

    // Next-state logic for Y4 (state D)
    assign Y4 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & w) | (y[4] & w) | (y[5] & w);

    // Output assignments
    assign Y1 = y[0];
    assign Y3 = y[3];
endmodule