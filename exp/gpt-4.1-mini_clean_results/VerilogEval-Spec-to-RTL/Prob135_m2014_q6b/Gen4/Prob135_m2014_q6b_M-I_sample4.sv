module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);
    // States encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101
    // Next-state y[1] logic from transitions:
    // Using Karnaugh map or logic minimization, next y[1] = w | (y[2] & ~y[1]) | (y[1] & ~y[0])

    assign Y1 = w | (y[2] & ~y[1]) | (y[1] & ~y[0]);

endmodule