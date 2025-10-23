module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = 
        (y == 3'b000 && w == 1'b0) ? 1'b0 : // From A to B
        (y == 3'b000 && w == 1'b1) ? 1'b0 : // From A to A
        (y == 3'b001 && w == 1'b0) ? 1'b0 : // From B to C
        (y == 3'b001 && w == 1'b1) ? 1'b1 : // From B to D
        (y == 3'b010 && w == 1'b0) ? 1'b0 : // From C to E
        (y == 3'b010 && w == 1'b1) ? 1'b1 : // From C to D
        (y == 3'b011 && w == 1'b0) ? 1'b1 : // From D to F
        (y == 3'b011 && w == 1'b1) ? 1'b0 : // From D to A
        (y == 3'b100 && w == 1'b0) ? 1'b0 : // From E to E
        (y == 3'b100 && w == 1'b1) ? 1'b1 : // From E to D
        (y == 3'b101 && w == 1'b0) ? 1'b0 : // From F to C
        (y == 3'b101 && w == 1'b1) ? 1'b1 : // From F to D
        1'b0;

endmodule