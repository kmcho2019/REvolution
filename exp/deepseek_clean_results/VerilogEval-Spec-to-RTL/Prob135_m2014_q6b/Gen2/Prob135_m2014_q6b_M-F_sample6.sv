module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;
assign y1_next = (~y[2] & ~y[1] & y[0]) |  // From B (001), goes to C/D (y[1]=1 in both cases)
                 (~y[2] & y[1] & ~y[0] & w) |  // From C (010) to D (011) when w=1
                 (y[2] & ~y[1] & ~y[0] & w) |  // From E (100) to D (011) when w=1
                 (y[2] & ~y[1] & y[0] & ~w);   // From F (101) to C (010) when w=0

endmodule