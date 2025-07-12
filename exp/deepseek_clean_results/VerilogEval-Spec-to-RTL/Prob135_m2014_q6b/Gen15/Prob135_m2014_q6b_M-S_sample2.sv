module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Simplified next-state logic for y[1]
    assign next_y1 = (~y[2] & y[0]) |         // B->C/D or F->C/D
                    (y[1] & ~y[0] & w) |     // C->D
                    (~y[2] & y[1] & ~w) |    // D->F
                    (y[2] & ~y[1] & w);      // E->D

endmodule