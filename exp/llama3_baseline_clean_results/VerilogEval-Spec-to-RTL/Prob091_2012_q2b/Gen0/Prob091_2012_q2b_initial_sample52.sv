module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    assign Y1 = (~y[5] & ~y[4] & ~y[3] & y[1] & ~y[0] & ~w) | // Transition from A to B
                 (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w); // Transition from D to B

    assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) | // State D
                 (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | // Transition from B to D
                 (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w) | // Transition from C to D
                 (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w); // Transition from F to D
endmodule