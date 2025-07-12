module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = 
        (y == 3'b001 && ~w) ||  // B to C
        (y == 3'b010 && ~w) ||  // C to E
        (y == 3'b010 && w) ||  // C to D
        (y == 3'b011 && ~w) ||  // D to F
        (y == 3'b100 && w) ||  // E stays E
        (y == 3'b100 && ~w) ||  // E to D
        (y == 3'b101 && w) ||  // F to D
        (y == 3'b101 && ~w);  // F to C

endmodule