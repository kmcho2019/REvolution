module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next-state logic for y[1] using Boolean expressions
    wire next_y1;
    assign next_y1 = (~y[2] & ~y[1] & y[0] & w) |  // State B (001) with w=1 -> D
                    (~y[2] & y[1] & ~y[0] & w) |   // State C (010) with w=1 -> D
                    (~y[2] & y[1] & y[0] & ~w) |   // State D (011) with w=0 -> F
                    (y[2] & ~y[1] & ~y[0] & w) |   // State E (100) with w=1 -> D
                    (y[2] & ~y[1] & y[0] & w);    // State F (101) with w=1 -> D

    // Output assignment
    assign Y1 = y[1];

endmodule