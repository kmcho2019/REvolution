module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    assign Y1 = (~w) & y[0]; // Y1 is 1 when current state is A and w = 0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]); // Y3 is 1 when current state is B, C, E, or F and w = 0
endmodule