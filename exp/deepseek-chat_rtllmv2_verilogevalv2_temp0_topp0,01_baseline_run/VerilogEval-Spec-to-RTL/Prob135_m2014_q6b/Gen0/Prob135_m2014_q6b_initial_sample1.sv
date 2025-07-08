module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
wire y1_next;
assign y1_next = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C (001,0->010)
                 (~y[2] & y[1] & ~y[0] & ~w) |  // C->E (010,0->100)
                 (~y[2] & y[1] & y[0] & ~w) |   // D->F (011,0->101)
                 (y[2] & ~y[1] & ~y[0] & w) |   // E->D (100,1->011)
                 (y[2] & ~y[1] & y[0] & w);      // F->D (101,1->011)

// Output assignment
assign Y1 = y[1];

endmodule