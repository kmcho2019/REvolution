module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Y1 = y[0] & w  (from A to B on input 1)
    assign Y1 = y[0] & w;

    // Y3 = (~w) & (y[1] | y[2] | y[3] | y[4] | y[5])
    // (From B,C,D,E,F states on input 0, go to D)
    assign Y3 = w_n & (y[1] | y[2] | y[3] | y[4] | y[5]);
endmodule