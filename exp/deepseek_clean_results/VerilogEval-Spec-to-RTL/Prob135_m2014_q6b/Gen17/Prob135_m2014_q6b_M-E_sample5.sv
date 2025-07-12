module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using gate-level implementation
    wire next_y1;
    assign next_y1 = 
        (~y[2] & ~y[1] & y[0] & w) |  // B->D when w=1
        (~y[2] & y[1] & ~y[0] & w) |  // C->D when w=1
        (~y[2] & y[1] & y[0] & ~w) |  // D->F when w=0
        (y[2] & ~y[1] & ~y[0] & w) |  // E->D when w=1
        (y[2] & ~y[1] & y[0] & ~w) |  // F->C when w=0
        (y[1] & ~(y[2] & y[0] & ~w)); // Maintain y[1] for other cases

endmodule