module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Simplified next-state logic for y[1]
    assign next_y1 = (~y[2] & y[0]) |         // From B (001) to C/D
                    (y[1] & ~y[0] & w) |     // From C (010) to D when w=1
                    (~y[2] & y[1] & ~w) |    // From D (011) to F when w=0
                    (y[2] & ~y[1] & w) |     // From E (100) to D when w=1
                    (y[2] & y[0]);           // From F (101) to C/D

endmodule