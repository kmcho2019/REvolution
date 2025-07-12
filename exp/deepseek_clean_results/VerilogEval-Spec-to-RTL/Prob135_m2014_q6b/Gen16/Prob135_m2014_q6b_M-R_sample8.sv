module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    assign next_y1 = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C (001->010)
                    (~y[2] & ~y[1] & y[0] & w)  |  // B->D (001->011)
                    (~y[2] & y[1] & ~y[0] & w)   |  // C->D (010->011)
                    (y[2] & ~y[1] & ~y[0] & w)  |  // E->D (100->011)
                    (y[2] & ~y[1] & y[0] & ~w)  |  // F->C (101->010)
                    (y[2] & ~y[1] & y[0] & w);     // F->D (101->011)

endmodule