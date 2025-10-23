module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1]
    // We only need to consider transitions that affect y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000 && w == 1) ||  // A to D
                     (y == 3'b001 && w == 1) ||  // B to D
                     (y == 3'b010 && w == 1) ||  // C to D
                     (y == 3'b011) ||            // D stays with y[1] = 1
                     (y == 3'b100) ||            // E stays with y[1] = 1
                     (y == 3'b101);              // F stays with y[1] = 1

endmodule