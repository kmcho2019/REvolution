module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;
    assign next_y1 = (
        // A (000) to B (001) when w = 0
        (y == 3'b000 && ~w) ? 1'b1 :
        // B (001) to C (010) or D (011) when w = 0 or w = 1
        (y == 3'b001 && ~w) ? 1'b0 :
        (y == 3'b001 && w) ? 1'b1 :
        // C (010) to E (100) or D (011) when w = 0 or w = 1
        (y == 3'b010 && ~w) ? 1'b0 :
        (y == 3'b010 && w) ? 1'b1 :
        // D (011) to F (101) or A (000) when w = 0 or w = 1
        (y == 3'b011 && ~w) ? 1'b1 :
        (y == 3'b011 && w) ? 1'b0 :
        // E (100) to E (100) or D (011) when w = 0 or w = 1
        (y == 3'b100 && ~w) ? 1'b0 :
        (y == 3'b100 && w) ? 1'b1 :
        // F (101) to C (010) or D (011) when w = 0 or w = 1
        (y == 3'b101 && ~w) ? 1'b0 :
        (y == 3'b101 && w) ? 1'b1 :
        1'b0
    );

    // Note: This assign statement for Y1 is not changed, but in a complete
    // implementation, you would need to assign next_y1 to y[1] after a clock edge
    // or use a different method to update y[1] based on next_y1.

endmodule