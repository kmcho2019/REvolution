module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    assign Y1 = (~w & y[0]) |          // A -> B when w=0
                (~w & y[5]);           // F -> C when w=0 (but C is y[2], not y[1], so this shouldn't be here)
                                       // Correction: Y1 should only be active when transitioning to B
    // Corrected Y1 implementation:
    assign Y1 = (~w & y[0]);           // Only A -> B transition sets Y1

    // Y3 is the next state for y[3] (state D)
    assign Y3 = (w & y[1]) |           // B -> D when w=1
                (w & y[2]) |           // C -> D when w=1
                (~w & y[3]) |          // D -> F when w=0 (but F is y[5], not y[3], so this shouldn't be here)
                (w & y[4]) |           // E -> D when w=1
                (w & y[5]);             // F -> D when w=1
    // Correction: Y3 should only be active when transitioning to D
    assign Y3 = (w & y[1]) |           // B -> D
                (w & y[2]) |           // C -> D
                (w & y[4]) |           // E -> D
                (w & y[5]);            // F -> D

endmodule