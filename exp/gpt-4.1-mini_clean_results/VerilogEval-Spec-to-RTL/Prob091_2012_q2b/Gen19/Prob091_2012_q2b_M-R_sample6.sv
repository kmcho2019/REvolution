module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Current states from one-hot encoding
    wire A = y[0];
    wire D = y[3];

    // Next state input for y[1] (state B): from A on w=1
    assign Y1 = A & w;

    // Next state input for y[3] (state D): from ~(A or D) and w=0
    assign Y3 = (~w) & (~A) & (~D);

endmodule