module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Logic for Y1 (input of state flip-flop y[1])
// Y1 should be 1 when the next state is B (000010) or E (010000)
assign Y1 = (y[0] &&!w) ||  // From A (000001) to B (000010)
           (y[1] && w) ||   // From B (000010) to C (000100) and then C to E is not possible, only E to E
           (y[4] && w);     // From E (010000) to E (010000)

// Logic for Y3 (input of state flip-flop y[3])
// Y3 should be 1 when the next state is C (000100) or D (001000)
assign Y3 = (y[1] && w) ||  // From B (000010) to C (000100)
           (y[2] &&!w) ||  // From C (000100) to D (001000)
           (y[0] && w) ||   // From A (000001) to D is not possible directly, but D can go to F and F can go to C and C to D
           (y[3] &&!w) ||  // From D (001000) to A (000001) and from A it can go to D via B and C
           (y[5] &&!w);    // From F (100000) to C (000100) and then from C it can go to D

endmodule