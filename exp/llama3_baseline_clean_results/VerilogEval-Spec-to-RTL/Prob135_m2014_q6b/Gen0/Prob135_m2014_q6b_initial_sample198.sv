module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

// next-state logic for y[1]
wire y1_next;

assign y1_next = (y == 3'b001) & ~w | // B to C or D
                 (y == 3'b010) & ~w | // C to E or D
                 (y == 3'b011) & ~w | // D to F or A
                 (y == 3'b100) & w  | // E to E or D
                 (y == 3'b101) & w  | // F to C or D
                 (y == 3'b000) & w;  // A to A

assign Y1 = y[1];

endmodule