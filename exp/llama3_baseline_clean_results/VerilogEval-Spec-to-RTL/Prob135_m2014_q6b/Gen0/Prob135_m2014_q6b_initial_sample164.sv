module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// next-state logic for y[1]
// for y[1] to be 1 in the next state, the following conditions must be met:
// (current state is B and w = 1) or 
// (current state is C and w = 1) or 
// (current state is D and w = 0) or 
// (current state is E) or 
// (current state is D and w = 1)
assign Y1_next = (y == 3'b001 && w == 1'b1) || 
                 (y == 3'b010 && w == 1'b1) || 
                 (y == 3'b011 && w == 1'b0) || 
                 (y == 3'b100) || 
                 (y == 3'b011 && w == 1'b1);

// the next state of y[1] is Y1_next
// assign Y1 = Y1_next; // for simulation purposes, can be removed

endmodule