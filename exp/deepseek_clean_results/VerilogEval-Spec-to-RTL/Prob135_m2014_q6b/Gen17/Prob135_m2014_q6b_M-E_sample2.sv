module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1] using optimized truth table approach
    wire next_y1 = 
        // Current state is B (001) and input is 1 -> transition to D (011)
        (y == 3'b001 && w) ||
        // Current state is C (010) and input is 1 -> transition to D (011)
        (y == 3'b010 && w) ||
        // Current state is D (011) and input is 0 -> transition to F (101)
        (y == 3'b011 && !w) ||
        // Current state is E (100) -> stays E (100) when w=0, goes to D (011) when w=1
        (y == 3'b100) ||
        // Current state is F (101) and input is 1 -> transition to D (011)
        (y == 3'b101 && w);

endmodule