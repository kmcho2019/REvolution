module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    wire next_y1;
    assign Y1 = y[1];

    // Next-state logic for y[1]
    assign next_y1 = (~y[2] & ~y[1] & y[0] & w) |  // From B (001) to D when w=1
                    (~y[2] & y[1] & ~y[0] & w) |   // From C (010) to D when w=1
                    (~y[2] & y[1] & y[0] & ~w) |  // From D (011) to F when w=0
                    (y[2] & ~y[1] & ~y[0] & w) |   // From E (100) to D when w=1
                    (y[2] & ~y[1] & y[0] & w);     // From F (101) to D when w=1

endmodule