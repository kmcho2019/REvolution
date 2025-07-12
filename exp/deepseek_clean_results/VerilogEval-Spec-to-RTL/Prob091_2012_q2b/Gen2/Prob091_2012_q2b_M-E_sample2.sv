module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // LUT-style implementation for state transitions

    // Y1 is active only when in state A (y[0]) and w=1
    assign Y1 = (y == 6'b000001) & w;

    // Y3 is active when in states B,C,E,F and w=0
    assign Y3 = ((y == 6'b000010) |  // State B
                (y == 6'b000100) |  // State C
                (y == 6'b010000) |  // State E
                (y == 6'b100000))   // State F
                & ~w;

endmodule