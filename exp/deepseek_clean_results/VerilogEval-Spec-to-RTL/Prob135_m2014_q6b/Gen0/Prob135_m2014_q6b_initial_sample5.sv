module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (~y[2] & y[1] & ~y[0] & ~w) |  // From C to E
                    (~y[2] & y[1] & y[0] & ~w) |   // From D to F
                    (y[2] & ~y[1] & ~y[0] & ~w);    // From E stays in E

endmodule