module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

assign y1_next = (~y[2] & ~y[1] & y[0]) |           // B->C/D (both make y[1]=1)
                 (y[2] & ~y[1] & ~y[0] & w) |       // E->D (y[1]=1)
                 (y[2] & ~y[1] & y[0]) |            // F->C/D (both make y[1]=1)
                 (~y[2] & y[1] & ~y[0] & w) |      // C->D (y[1]=1)
                 (~y[2] & y[1] & y[0] & ~w);       // D->F (y[1]=0) covered by absence

// y[1] will be 0 in all other cases:
// - State A (000) stays 0
// - C->E (y[1]=0) when w=0
// - D->A (y[1]=0) when w=1
// - E stays (y[1]=0) when w=0

endmodule