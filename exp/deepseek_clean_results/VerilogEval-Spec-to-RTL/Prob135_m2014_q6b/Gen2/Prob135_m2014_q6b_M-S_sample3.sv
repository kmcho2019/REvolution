module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// Simplified next-state logic for y[1]
assign y[1] = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C when w=0
              (~y[2] & y[1] & ~y[0] & w)  |  // C->D when w=1
              (y[2] & ~y[1] & ~y[0] & w)  |  // E->D when w=1
              (y[2] & ~y[1] & y[0] & ~w);    // F->C when w=0

endmodule