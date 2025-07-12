module TopModule(
    input  [5:0] y,  // Current state
    input        w,  // Input to determine next state
    output       Y1,  // Next state bit corresponding to state A
    output       Y3   // Next state bit corresponding to state C
);

// Assign Y1 based on the condition that the next state should be A (y[0]=1) 
// if the current state is D and w is 1. Since D is represented as 001000, 
// y[3] is the bit that indicates D.
assign Y1 = y[3] & w;

// Assign Y3 based on the condition that the next state should be C (y[2]=1) 
// if the current state is F and w is 0, or if the current state is B and w is 0.
// F is represented as 100000 and B as 000010. So, y[5] indicates F and y[1] indicates B.
assign Y3 = (y[5] & ~w) | (y[1] & ~w);

endmodule