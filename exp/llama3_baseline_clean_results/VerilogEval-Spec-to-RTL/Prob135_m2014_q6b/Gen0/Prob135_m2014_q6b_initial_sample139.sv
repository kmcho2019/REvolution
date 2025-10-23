module TopModule (
    input  [2:0] y,  // current state
    input        w,  // input
    output       Y1  // next-state logic for y[1]
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b001 && w == 0) || // B (001) to C (010)
            (y == 3'b001 && w == 1) || // B (001) to D (011)
            (y == 3'b010 && w == 1) || // C (010) to D (011)
            (y == 3'b011) || // D (011) stays D (011) or goes to A (000) or F (101)
            (y == 3'b100 && w == 1) || // E (100) to D (011)
            (y == 3'b101 && w == 1);   // F (101) to D (011)

endmodule