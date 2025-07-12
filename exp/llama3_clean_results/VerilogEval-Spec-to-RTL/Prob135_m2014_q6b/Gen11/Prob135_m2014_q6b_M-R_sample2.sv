module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = 
    (y == 3'b000 && !w) ? 0 : // A to B
    (y == 3'b000 && w)  ? 0 : // A stays A
    (y == 3'b001 && !w) ? 0 : // B to C
    (y == 3'b001 && w)  ? 1 : // B to D
    (y == 3'b010 && !w) ? 1 : // C to E
    (y == 3'b010 && w)  ? 1 : // C to D
    (y == 3'b011 && !w) ? 0 : // D to F
    (y == 3'b011 && w)  ? 0 : // D to A
    (y == 3'b100 && !w) ? 1 : // E stays E
    (y == 3'b100 && w)  ? 1 : // E to D
    (y == 3'b101 && !w) ? 0 : // F to C
    (y == 3'b101 && w)  ? 1; // F to D

endmodule