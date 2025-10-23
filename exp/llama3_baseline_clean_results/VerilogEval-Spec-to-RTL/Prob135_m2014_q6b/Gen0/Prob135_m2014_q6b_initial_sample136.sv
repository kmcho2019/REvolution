module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Output Y1 is simply y[1]
assign Y1 = y[1];

// Next state logic for y[1]
// y[1] will be 1 in the next state when the current state is D (y = 100) and w is 1,
// or when the current state is E (y = 101) or F (y = 110) regardless of the value of w
// y[1] will be 0 in the next state otherwise
assign next_y1 = (y == 3'b100 && w) || (y == 3'b101) || (y == 3'b110);

endmodule