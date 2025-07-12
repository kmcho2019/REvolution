module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
wire y1_next = (~y[2] & ~y[1] & y[0]) |          // State B (001)
               (~y[2] & y[1] & ~y[0] & w) |      // State C (010) when w=1
               (y[2] & ~y[1] & ~y[0] & w) |      // State E (100) when w=1
               (y[2] & ~y[1] & y[0] & w);        // State F (101) when w=1

assign Y1 = y[1];

endmodule