module TopModule (
    input  [5:0] y,   // current state one-hot: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // next-state signal for state B (y[1])
    output       Y3   // next-state signal for state D (y[3])
);

assign Y1 = y[0] & ~w;
assign Y3 = w & (|y[5:1]);

endmodule