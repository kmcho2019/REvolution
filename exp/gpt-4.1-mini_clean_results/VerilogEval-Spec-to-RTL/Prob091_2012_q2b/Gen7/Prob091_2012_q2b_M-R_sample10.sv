module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Localparams for state indices to improve readability
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;
    localparam E = 4;
    localparam F = 5;

    // Y1 is next input for y[B]: from A on w=1
    assign Y1 = y[A] & w;

    // Y3 is next input for y[D]: from B,C,E,F on w=0
    assign Y3 = (y[B] | y[C] | y[E] | y[F]) & (~w);

endmodule