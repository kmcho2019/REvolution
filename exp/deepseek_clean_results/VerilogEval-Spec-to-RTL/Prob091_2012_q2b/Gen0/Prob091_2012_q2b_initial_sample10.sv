module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 represents the next state for y[1] (state B)
    // B is only entered from A when w=1
    assign Y1 = (y == 6'b000001) & w;

    // Y3 represents the next state for y[3] (state D)
    // D is entered from B, C, E, or F when w=0
    assign Y3 = ((y == 6'b000010) |  // B
                (y == 6'b000100) |  // C
                (y == 6'b010000) |   // E
                (y == 6'b100000))   // F
                & ~w;

endmodule