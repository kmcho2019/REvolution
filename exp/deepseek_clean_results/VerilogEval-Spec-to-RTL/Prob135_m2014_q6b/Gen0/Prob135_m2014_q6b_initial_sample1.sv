module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
wire y1_next;
assign y1_next = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C when w=0
                  (y[2] & ~y[1] & y[0] & ~w) |   // F->C when w=0
                  (~y[2] & y[1] & ~y[0] & w) |   // C->D when w=1
                  (y[2] & ~y[1] & ~y[0] & w);    // E->D when w=1

// Output assignment
assign Y1 = y[1];

endmodule