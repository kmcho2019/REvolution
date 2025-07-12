module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;
// y[1] becomes 1 in next state for these transitions:
wire y1_set = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C
              (~y[2] & y[1] & ~y[0] & w)  |  // C->D
              (y[2] & ~y[1] & ~y[0] & w)  |  // E->D
              (y[2] & ~y[1] & y[0] & ~w);    // F->C

// y[1] becomes 0 in next state for these transitions:
wire y1_clear = (~y[2] & ~y[1] & ~y[0] & ~w) |  // A->B
                (~y[2] & ~y[1] & y[0] & w)   |  // B->D
                (~y[2] & y[1] & ~y[0] & ~w)  |  // C->E
                (~y[2] & y[1] & y[0] & w)    |  // D->A
                (~y[2] & y[1] & y[0] & ~w)  |  // D->F
                (y[2] & ~y[1] & y[0] & w);     // F->D

// Next state logic:
assign y1_next = y1_set | (y[1] & ~y1_clear);

endmodule