module TopModule (
    input  [5:0] y,  // Current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1, // Next state's B bit (y[1])
    output       Y3  // Next state's D bit (y[3])
);

    assign Y1 = y[0] & ~w;                     // From A to B on w=0
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]); // From B-F to D on w=1

endmodule