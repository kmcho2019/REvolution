module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = ((~y[2] & ~y[1] & ~y[0] & ~w) ? 1'b1 : // A to B
                (~y[2] & ~y[1] & y[0] & w) ? 1'b0 : // A to A
                (~y[2] & y[1] & ~y[0] & ~w) ? 1'b1 : // B to C
                (~y[2] & y[1] & ~y[0] & w) ? 1'b1 : // B to D
                (~y[2] & y[1] & y[0] & ~w) ? 1'b0 : // C to E
                (~y[2] & y[1] & y[0] & w) ? 1'b1 : // C to D
                (y[2] & ~y[1] & ~y[0] & ~w) ? 1'b1 : // D to F
                (y[2] & ~y[1] & ~y[0] & w) ? 1'b0 : // D to A
                (y[2] & y[1] & ~y[0] & ~w) ? 1'b0 : // E to E
                (y[2] & y[1] & ~y[0] & w) ? 1'b1 : // E to D
                (y[2] & y[1] & y[0] & ~w) ? 1'b1 : // F to C
                (y[2] & y[1] & y[0] & w) ? 1'b1); // F to D

endmodule