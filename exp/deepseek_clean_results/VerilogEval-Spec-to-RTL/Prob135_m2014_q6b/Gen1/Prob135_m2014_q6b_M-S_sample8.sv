module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Simplified next-state logic for y[1]
wire y1_next;
assign y1_next = (~y[2] & ~y[1] & y[0] & w) |  // State B (001) and w=1 -> D (011)
                 (~y[2] & y[1] & ~y[0] & ~w) |  // State C (010) and w=0 -> E (100)
                 (~y[2] & y[1] & y[0] & ~w) |   // State D (011) and w=0 -> F (101)
                 (y[2] & ~y[1] & ~y[0] & ~w);   // State E (100) and w=0 -> E (100)

// Output assignment
assign Y1 = y[1];

endmodule