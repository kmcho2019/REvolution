module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// next state logic for y[1]
assign next_y1 = (y == 3'b001 && w == 0) ? 1'b0 : // from B to C
                 (y == 3'b001 && w == 1) ? 1'b1 : // from B to D
                 (y == 3'b010 && w == 0) ? 1'b1 : // from C to E
                 (y == 3'b010 && w == 1) ? 1'b1 : // from C to D
                 (y == 3'b100 && w == 0) ? 1'b0 : // from D to F
                 (y == 3'b100 && w == 1) ? 1'b0 : // from D to A
                 (y == 3'b011 && w == 0) ? 1'b1 : // from F to C
                 (y == 3'b011 && w == 1) ? 1'b1 : // from F to D
                 (y == 3'b101 && w == 0) ? 1'b1 : // from E to E
                 (y == 3'b101 && w == 1) ? 1'b1 : 1'b0; // from E to D, others

// Use next_y1 for further processing
endmodule