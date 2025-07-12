module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next state logic for y[1]
wire next_y1;
assign next_y1 = (~y[2] & ~y[1] & y[0]) |          // State B (001) -> C or D (both set y[1]=1)
                 (~y[2] & y[1] & ~y[0] & ~w) |     // State C (010) and w=0 -> E (clear y[1]=0)
                 (~y[2] & y[1] & y[0]) |           // State D (011) -> F or A (both clear y[1]=0)
                 (y[2] & ~y[1] & ~y[0] & w) |     // State E (100) and w=1 -> D (set y[1]=1)
                 (y[2] & ~y[1] & y[0]);            // State F (101) -> C or D (both set y[1]=1)

// Output is current y[1]
assign Y1 = y[1];

endmodule