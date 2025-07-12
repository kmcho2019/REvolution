module TopModule(
    input [5:0] y,  // current state
    input w,        // input
    output Y1,      // input of state flip-flop y[1]
    output Y3       // input of state flip-flop y[3]
);

// Next state logic based on current state and input w
// A (000001) --1--> B, --0--> A
// B (000010) --1--> C, --0--> D
// C (000100) --1--> E, --0--> D
// D (001000) --1--> F, --0--> A
// E (010000) --1--> E, --0--> D
// F (100000) --1--> C, --0--> D

// Y1 is 1 when the next state is B
assign Y1 = (y[0] &&!w) || (y[0] && w);  // A -> B or A -> A, but only when going to B

// Corrected Y1 Logic:
assign Y1 = (y[0] && w);  // Only when A transitions to B

// Y3 is 1 when the next state is D
assign Y3 = (y[1] &&!w) || (y[2] &&!w) || (y[4] &&!w) || (y[5] &&!w) || (y[0] &&!w);
// B -> D, C -> D, E -> D, F -> D, or A -> A doesn't matter for D, but A -> D isn't a transition

// Simplified Y3 Logic based on the actual transitions:
assign Y3 = (y[1] &&!w) || (y[2] &&!w) || (y[4] &&!w) || (y[5] &&!w) || (y[0] &&!w);

// Final simplification for Y3:
assign Y3 = (y[0] &&!w) || (y[1] &&!w) || (y[2] &&!w) || (y[4] &&!w) || (y[5] &&!w);

endmodule