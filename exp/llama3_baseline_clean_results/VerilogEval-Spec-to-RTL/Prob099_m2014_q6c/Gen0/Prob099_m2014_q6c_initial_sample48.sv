module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Assign outputs directly from input y
assign Y1 = y[0];
assign Y3 = y[2];

// Next-state logic for Y2 (y[1])
// State B goes to A when w = 1, so y[1] = 1 when y[1] = 1 and w = 1
// State D goes to A when w = 1, so y[1] = 1 when y[3] = 1 and w = 1
// State D goes to B when w = 0, so y[1] = 1 when y[3] = 1 and w = 0
assign Y2 = (y[1] && w) || (y[3] && w) || (y[3] && ~w);

// Next-state logic for Y4 (y[3])
// State C goes to D when w = 1, so y[3] = 1 when y[2] = 1 and w = 1
// State D goes to D when w = 1, so y[3] = 1 when y[3] = 1 and w = 1
// State E goes to D when w = 1, so y[3] = 1 when y[4] = 1 and w = 1
// State F goes to D when w = 1, so y[3] = 1 when y[5] = 1 and w = 1
assign Y4 = (y[2] && w) || (y[3] && w) || (y[4] && w) || (y[5] && w);

endmodule