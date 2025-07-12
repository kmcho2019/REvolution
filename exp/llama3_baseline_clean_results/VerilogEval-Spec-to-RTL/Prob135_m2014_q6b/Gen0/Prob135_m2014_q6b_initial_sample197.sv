module TopModule (
    input  [2:0] y,
    input         w,
    output        Y1
);

// The current state of y[1] is directly assigned to Y1
assign Y1 = y[1];

// Next-state logic for y[1]
wire next_y1;
assign next_y1 = (
    // Current state A (000) and input w = 1, stay in A (000)
    (y == 3'b000 && w == 1) ? 1'b0 :
    // Current state A (000) and input w = 0, go to B (001)
    (y == 3'b000 && w == 0) ? 1'b0 :
    // Current state B (001) and input w = 1, go to D (100)
    (y == 3'b001 && w == 1) ? 1'b1 :
    // Current state B (001) and input w = 0, go to C (010)
    (y == 3'b001 && w == 0) ? 1'b0 :
    // Current state C (010) and input w = 1, go to D (100)
    (y == 3'b010 && w == 1) ? 1'b1 :
    // Current state C (010) and input w = 0, go to E (011) then E stays in E but we consider next possible state
    (y == 3'b010 && w == 0) ? 1'b0 :
    // Current state D (100) and input w = 1, go to A (000)
    (y == 3'b100 && w == 1) ? 1'b0 :
    // Current state D (100) and input w = 0, go to F (101)
    (y == 3'b100 && w == 0) ? 1'b1 :
    // Current state E (011) and input w = 1, go to D (100)
    (y == 3'b011 && w == 1) ? 1'b1 :
    // Current state E (011) and input w = 0, stay in E (011)
    (y == 3'b011 && w == 0) ? 1'b0 :
    // Current state F (101) and input w = 1, go to D (100)
    (y == 3'b101 && w == 1) ? 1'b1 :
    // Current state F (101) and input w = 0, go to C (010)
    (y == 3'b101 && w == 0) ? 1'b0 : 1'b0
);

endmodule