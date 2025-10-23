module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

assign y1_next = (~y[2] & y[1] & ~y[0]) |        // B->C/D
                 (y[1] & ~y[0] & w) |            // C->D
                 (~y[2] & y[1] & y[0] & ~w) |    // D->F
                 (y[2] & ~y[1] & ~y[0] & w) |    // E->D
                 (y[2] & ~y[1] & y[0]);         // F->C/D

endmodule