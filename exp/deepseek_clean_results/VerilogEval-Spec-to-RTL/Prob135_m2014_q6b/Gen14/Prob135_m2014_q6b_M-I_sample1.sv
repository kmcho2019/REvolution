module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct and complete next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000 & ~w) ? 1'b0 :  // A->B
                    (y == 3'b001 & ~w) ? 1'b0 :  // B->C
                    (y == 3'b011 & ~w) ? 1'b0 :  // D->F
                    (y == 3'b101 & ~w) ? 1'b0 :  // F->C
                    (y == 3'b001 & w)  ? 1'b1 :  // B->D
                    (y == 3'b010 & w)  ? 1'b1 :  // C->D
                    (y == 3'b010 & ~w) ? 1'b1 :  // C->E
                    (y == 3'b100 & w)  ? 1'b1 :  // E->D
                    (y == 3'b101 & w)  ? 1'b1 :  // F->D
                    y[1];                       // Default: keep current value

endmodule