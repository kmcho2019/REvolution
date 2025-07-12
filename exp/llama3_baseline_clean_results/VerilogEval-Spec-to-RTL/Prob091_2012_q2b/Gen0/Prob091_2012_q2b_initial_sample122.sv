module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 corresponds to the input of state flip-flop y[1], which is state B
// From the state machine, B is entered from A when w is 1
assign Y1 = (y[0] && w); // A (000001) to B transition when w=1

// Y3 corresponds to the input of state flip-flop y[3], which is state D
// D is entered from B when w=0, from C when w=0, from E when w=0, and from D when w=0
assign Y3 = (!w && (y[1] || y[2] || y[4] || y[3])); // Transition to D when w=0 from B, C, E, or D

endmodule