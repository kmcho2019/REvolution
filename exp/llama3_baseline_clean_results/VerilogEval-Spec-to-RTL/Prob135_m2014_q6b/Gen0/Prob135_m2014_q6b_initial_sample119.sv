module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    // Next-state logic for y[1]
    assign Y1 = (y[1]);

    // K-map or truth table analysis
    // y[1] is 1 for states C, D, E, and F
    // next_y1 = (y == 3'b100) || (y == 3'b101) || (y == 3'b110) || (y == 3'b111)
    // But we are implementing just the next-state logic for y[1]
    // next_y1 = y[1]

endmodule