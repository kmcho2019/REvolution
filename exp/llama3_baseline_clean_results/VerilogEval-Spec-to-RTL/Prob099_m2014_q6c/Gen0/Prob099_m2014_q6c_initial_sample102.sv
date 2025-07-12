module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y2 (next state B) is 1 when current state is A and w is 0
    assign Y1 = ~w & y[0];

    // Y4 (next state D) is 1 when current state is B, C, E, or F and w is 1
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);
endmodule