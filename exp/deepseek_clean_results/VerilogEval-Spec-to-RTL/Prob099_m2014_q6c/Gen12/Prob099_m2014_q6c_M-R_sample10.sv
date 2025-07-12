module TopModule(
    input [5:0] y,
    input w,
    output Y2,  // Next state y[1] (state B)
    output Y4   // Next state y[3] (state D)
);

    // Y2 is active only when transitioning from A to B (A with w=0)
    assign Y2 = y[0] & ~w;

    // Y4 is active when transitioning to D from:
    // B with w=1, C with w=1, E with w=1, or F with w=1
    assign Y4 = (y[1] & w) |  // B→D
                (y[2] & w) |  // C→D
                (y[4] & w) |  // E→D
                (y[5] & w);   // F→D

endmodule