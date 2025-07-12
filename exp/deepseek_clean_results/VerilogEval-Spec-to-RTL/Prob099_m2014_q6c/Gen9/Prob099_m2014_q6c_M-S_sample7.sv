module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[4] | y[5];
    assign Y3 = (y[0] & w) |          // A with w=1 stays in A
                (y[1] & w) |          // B with w=1 goes to D
                (y[2] & w) |          // C with w=1 goes to D
                (y[3] & ~w) |         // D with w=0 goes to F
                (y[4] & w) |          // E with w=1 goes to D
                (y[5] & w);           // F with w=1 goes to D

endmodule