module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    assign Y1 = (y[3] & w); // y[3] corresponds to state D, w = 1 transitions to A
    assign Y3 = (y[1] & ~w) | (y[5] & ~w); // y[1] corresponds to state B, y[5] to F, w = 0 transitions to C
endmodule