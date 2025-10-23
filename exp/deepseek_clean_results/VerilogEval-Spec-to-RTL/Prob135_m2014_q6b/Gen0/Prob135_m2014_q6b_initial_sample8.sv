module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (~y[2] & y[1] & ~y[0] & w) |  // C->D when w=1
                     (~y[2] & y[1] & y[0] & ~w) |  // D->F when w=0
                     (y[2] & ~y[1] & ~y[0] & w) |   // E->D when w=1
                     (y[2] & ~y[1] & y[0] & w);     // F->D when w=1

    // Output assignment
    assign Y1 = y[1];

endmodule