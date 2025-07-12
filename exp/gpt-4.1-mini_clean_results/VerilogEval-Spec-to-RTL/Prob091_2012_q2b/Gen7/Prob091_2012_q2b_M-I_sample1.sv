module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // State bit indices for clarity
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;
    localparam E = 4;
    localparam F = 5;

    // Next state input logic for y[1] (state B)
    assign Y1 = y[A] & w;

    // Next state input logic for y[3] (state D)
    assign Y3 = (~w) & (y[B] | y[C] | y[E] | y[F]);
endmodule