module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Local parameters for readability (state bits)
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;
    localparam E = 4;
    localparam F = 5;

    wire w_n = ~w;

    // Next-state input for y[1] (state B): transition from A on w=1
    assign Y1 = y[A] & w;

    // Next-state input for y[3] (state D): transitions from B,C,E,F on w=0
    assign Y3 = w_n & ~(y[A] | y[D]);

endmodule