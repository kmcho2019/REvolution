module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

assign Y1 = y[1];

// Next-state logic for y[1]
// For states A (000) and B (001), y[1] is 0, and y[1]_next = 0 if w = 0 or 1
// For states C (010), y[1] is 1, and y[1]_next = 1 if w = 0, and 1 if w = 1
// For states D (011), y[1] is 1, and y[1]_next = 0 if w = 0, and 0 if w = 1
// For states E (100), y[1] is 0, and y[1]_next = 0 if w = 0 or 1
// For states F (101), y[1] is 0, and y[1]_next = 1 if w = 0, and 0 if w = 1

// Deriving the next-state equation for y[1] based on the above transitions:
// y[1]_next = (y[2] & ~y[1] & ~y[0] & w) | (~y[2] & y[1] & ~y[0] & ~w) | (~y[2] & ~y[1] & y[0] & ~w)

// assign y1_next = (y[2] & ~y[1] & ~y[0] & w) | (~y[2] & y[1] & ~y[0] & ~w) | (~y[2] & ~y[1] & y[0] & ~w);
// Since we only need the combinational logic for y[1]_next, we can directly use the current state y[1]
// However, the above equation can be used to derive the next-state logic for y[1]

endmodule