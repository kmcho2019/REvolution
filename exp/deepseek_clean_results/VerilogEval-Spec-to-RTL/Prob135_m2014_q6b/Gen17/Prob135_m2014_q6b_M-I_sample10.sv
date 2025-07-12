module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    assign next_y1 = (~y[2] & ~y[1] & y[0]) |  // From B (001): goes to C/D (y[1]=1)
                    (~y[2] & y[1] & ~y[0] & w) |  // From C (010): goes to D when w=1
                    (y[2] & ~y[1] & ~y[0] & w) |  // From E (100): goes to D when w=1
                    (y[2] & ~y[1] & y[0]);        // From F (101): goes to C/D (y[1]=1)

endmodule