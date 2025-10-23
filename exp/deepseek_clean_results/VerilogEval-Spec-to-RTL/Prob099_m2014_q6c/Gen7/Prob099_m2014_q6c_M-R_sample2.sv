module TopModule(
    input [5:0] y,  // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,
    output Y1,      // next y[0] (state A)
    output Y3       // next y[3] (state D)
);

    assign Y1 = (y[0] & w) | (y[3] & w);
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule