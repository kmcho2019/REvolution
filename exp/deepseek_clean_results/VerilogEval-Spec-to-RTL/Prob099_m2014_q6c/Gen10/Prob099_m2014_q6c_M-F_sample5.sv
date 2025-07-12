module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[0] & ~w;  // A with w=0 goes to B (y[1])
    assign Y4 = (y[1] & w) |  // B with w=1 goes to D (y[3])
                (y[2] & w) |  // C with w=1 goes to D
                (y[3] & ~w) | // D with w=0 goes to F
                (y[4] & w) |  // E with w=1 goes to D
                (y[5] & w);   // F with w=1 goes to D

endmodule