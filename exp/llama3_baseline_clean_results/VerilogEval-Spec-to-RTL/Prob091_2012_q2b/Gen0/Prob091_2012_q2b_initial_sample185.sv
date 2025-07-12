module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y1 should be 1 when the next state is B
    assign Y1 = (y[0] && !w) || (y[1] && !w) || (y[2] && !w) || (y[4] && w);

    // Y3 should be 1 when the next state is D
    assign Y3 = (y[0] && w) || (y[1] && !w) || (y[2] && !w) || (y[3] && w) || (y[5] && !w);
endmodule