module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000 && w) || // A -> A (no change)
                      (y == 3'b001 && w) || // B -> D
                      (y == 3'b010 &&!w) || // C -> C or E (no change)
                      (y == 3'b010 && w) || // C -> D
                      (y == 3'b011 &&!w) || // D -> F
                      (y == 3'b011 && w) || // D -> A (no change)
                      (y == 3'b100 && w) || // E -> D
                      (y == 3'b101 &&!w) || // F -> C (no change)
                      (y == 3'b101 && w);    // F -> D

endmodule