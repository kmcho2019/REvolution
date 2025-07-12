module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

assign y1_next = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C (001->010)
                 (y[1] & ~y[0] & w) |           // C->D (010->011)
                 (~y[2] & y[1] & y[0] & ~w) |   // D->F (011->101)
                 (y[2] & ~y[1] & ~y[0] & w) |   // E->D (100->011)
                 (y[2] & ~y[1] & y[0]);         // F->C/D (101->010/011)

endmodule