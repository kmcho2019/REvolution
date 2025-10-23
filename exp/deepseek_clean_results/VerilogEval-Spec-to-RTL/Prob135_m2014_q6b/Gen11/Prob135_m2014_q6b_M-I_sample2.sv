module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // State decoding
    wire isA = (y == 3'b000);
    wire isB = (y == 3'b001);
    wire isC = (y == 3'b010);
    wire isD = (y == 3'b011);
    wire isE = (y == 3'b100);
    wire isF = (y == 3'b101);

    // Next-state logic for y[1]
    wire next_y1 = 
        (isA & ~w) |               // A→B (001)
        (isB & w) |                // B→D (011)
        (isC & w) |                // C→D (011)
        (isD & w) |                // D→A (000)
        (isE & w) |                // E→D (011)
        (isF & w) | (isF & ~w);    // F→D (011) or F→C (010)

endmodule