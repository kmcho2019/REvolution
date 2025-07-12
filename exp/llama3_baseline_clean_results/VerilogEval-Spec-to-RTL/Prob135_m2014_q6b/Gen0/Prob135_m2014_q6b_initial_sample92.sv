module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
assign Y1 = 
    (~y[2] & ~y[1] & ~y[0] & w) |  // A (000) to A (000)
    (~y[2] & ~y[1] & y[0] & w) |  // B (001) to D (100)
    (~y[2] & y[1] & ~y[0] & w) |  // C (010) to D (100)
    (~y[2] & y[1] & y[0] & ~w) |  // D (011) to A (000)
    (y[2] & ~y[1] & ~y[0] & w) |  // E (100) to D (100)
    (y[2] & y[1] & ~y[0] & ~w);  // F (101) to C (010)

endmodule