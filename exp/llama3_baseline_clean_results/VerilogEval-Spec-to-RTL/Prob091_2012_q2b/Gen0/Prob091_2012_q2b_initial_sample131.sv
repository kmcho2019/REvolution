module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y1 is high when the current state is A and w is 1
    assign Y1 = y[0] && w;

    // Y3 is high when the next state is D
    assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[3] && ~w) || (y[4] && ~w);
endmodule