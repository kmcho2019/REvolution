module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire t1 = ~y[1] & y[0];
    wire t2 = (y[1] | y[2]) & ~y[0];

    assign Y1 = t1 | (w & t2);

endmodule