module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y1 corresponds to state B, which is next state when current state is A and w is 1
    assign Y1 = y[0] && w;

    // Y3 corresponds to state D, which is next state in several conditions
    assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[5] && ~w) || (y[3] && ~w);
endmodule