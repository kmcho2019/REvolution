module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// Next-state logic for y[1]
wire y1_next;
assign y1_next = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C (001->010)
                 (y[1] & ~w) |                   // C->E (010->100) maintains 0
                 (y[1] & w) |                    // C->D (010->011) maintains 1
                 (y[2] & ~y[1] & ~y[0] & w) |    // E->D (100->011)
                 (y[2] & ~y[1] & y[0] & ~w);     // F->C (101->010)

endmodule