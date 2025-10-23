module good1 (
    input  [5:0] y,   // one-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2,  // next-state signal for state B (y[1])
    output       Y4   // next-state signal for state D (y[3])
);

assign Y2 = y[0] & ~w;
assign Y4 = w & (|y[5:1]);

endmodule