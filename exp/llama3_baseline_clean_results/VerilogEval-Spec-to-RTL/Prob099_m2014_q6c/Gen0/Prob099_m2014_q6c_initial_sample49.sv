module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next-state signals Y2 and Y4 are not used in this module
// We only need to implement the logic for Y1 and Y3

// Y1 corresponds to state B
assign Y1 = (y[5:0] == 6'b000010) ? 1'b1 : 1'b0;

// However, Y1 is output, so we need the next state of B 
// If the current state is B and w is 0, then the next state is C
// If the current state is B and w is 1, then the next state is D
// If the current state is A and w is 1, then the next state is A
// If the current state is A and w is 0, then the next state is B
// So the next state of B (Y1) will be set when the current state is A and w is 0
// Or when the current state is C and w is 1
// Or when the current state is E and w is 0
// Or when the current state is F and w is 1
assign Y1 = (y[5:0] == 6'b000001 && w == 1'b0) || 
            (y[5:0] == 6'b000100 && w == 1'b1) || 
            (y[5:0] == 6'b100000 && w == 1'b0) || 
            (y[5:0] == 6'b010000 && w == 1'b1);

// Y3 corresponds to state D
// If the current state is D and w is 0, then the next state is F
// If the current state is D and w is 1, then the next state is A
// If the current state is B and w is 1, then the next state is D
// If the current state is C and w is 1, then the next state is D
// If the current state is E and w is 1, then the next state is D
// So the next state of D (Y3) will be set when the current state is B and w is 1
// Or when the current state is C and w is 1
// Or when the current state is E and w is 1
assign Y3 = (y[5:0] == 6'b000010 && w == 1'b1) || 
            (y[5:0] == 6'b000100 && w == 1'b1) || 
            (y[5:0] == 6'b100000 && w == 1'b1);

endmodule