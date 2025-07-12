module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    assign Y1 = (y[0] && w); // transition to state B from A
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w); // transition to state D from B, C, or E
endmodule