module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000 & w) ? 0 :          // A: stays A (0) or -> B (0)
        (y == 3'b001 & w) ? 1 :          // B: -> D (1) if w=1, else -> C (0)
        (y == 3'b010 & w) ? 1 :          // C: -> D (1) if w=1, else -> E (0)
        (y == 3'b011 & ~w) ? 1 :         // D: -> F (1) if w=0, else -> A (0)
        (y == 3'b100) ? 1 :              // E: stays E (1) or -> D (1)
        (y == 3'b101 & w) ? 1 : 0;       // F: -> D (1) if w=1, else -> C (0)

endmodule