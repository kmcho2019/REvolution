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
    wire next_y1;
    assign next_y1 = 
        (isA & w) ? 1'b0 :       // A→A: keep 0
        (isA & ~w) ? 1'b0 :      // A→B: set 0 (but B has y[1]=0, next state will be 001)
        (isB & ~w) ? 1'b1 :      // B→C: set 1 (C is 010)
        (isB & w) ? 1'b1 :       // B→D: set 1 (D is 011)
        (isC & ~w) ? 1'b0 :      // C→E: set 0 (E is 100)
        (isC & w) ? 1'b1 :        // C→D: set 1 (D is 011)
        (isD & ~w) ? 1'b0 :      // D→F: set 0 (F is 101)
        (isD & w) ? 1'b0 :        // D→A: set 0 (A is 000)
        (isE & ~w) ? 1'b0 :       // E→E: keep 0
        (isE & w) ? 1'b1 :        // E→D: set 1 (D is 011)
        (isF & ~w) ? 1'b1 :      // F→C: set 1 (C is 010)
        (isF & w) ? 1'b1 :        // F→D: set 1 (D is 011)
        1'b0;                     // Default case (shouldn't occur)

endmodule