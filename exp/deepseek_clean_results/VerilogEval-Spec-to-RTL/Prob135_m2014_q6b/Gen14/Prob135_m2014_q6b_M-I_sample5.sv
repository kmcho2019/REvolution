module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;

    // Boolean expression for next y[1] derived from state transitions
    assign next_y1 = (~y[2] & ~y[1] & y[0] & ~w) |  // B->C (001,0)->1
                    (~y[2] & ~y[1] & y[0] & w)  |  // B->D (001,1)->1
                    (~y[2] & y[1] & ~y[0] & w)  |  // C->D (010,1)->1
                    (y[2] & ~y[1] & ~y[0] & w)  |  // E->D (100,1)->1
                    (y[2] & ~y[1] & y[0] & ~w) |   // F->C (101,0)->1
                    (y[2] & ~y[1] & y[0] & w);     // F->D (101,1)->1

endmodule