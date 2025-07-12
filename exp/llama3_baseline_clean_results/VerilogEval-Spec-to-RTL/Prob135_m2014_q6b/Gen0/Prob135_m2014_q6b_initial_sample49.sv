module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b000 && w == 1'b1) ? 1'b0 : // A to A
           (y == 3'b001 && w == 1'b0) ? 1'b0 : // B to C
           (y == 3'b001 && w == 1'b1) ? 1'b1 : // B to D
           (y == 3'b010 && w == 1'b0) ? 1'b0 : // C to E
           (y == 3'b010 && w == 1'b1) ? 1'b1 : // C to D
           (y == 3'b011 && w == 1'b0) ? 1'b1 : // D to F
           (y == 3'b011 && w == 1'b1) ? 1'b0 : // D to A
           (y == 3'b100 && w == 1'b0) ? 1'b0 : // E to E
           (y == 3'b100 && w == 1'b1) ? 1'b1 : // E to D
           (y == 3'b101 && w == 1'b0) ? 1'b0 : // F to C
           (y == 3'b101 && w == 1'b1) ? 1'b1 : 1'b0; // F to D, default to 0 if not matched

endmodule