module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is set when the next state is B or D
assign Y1 = (y[0] &&!w) ||  // A -> B (w = 0) or A -> A (w = 0) is not a case for Y1
           (y[1] &&!w) ||  // B -> D (w = 0)
           (y[2] &&!w) ||  // C -> D (w = 0)
           (y[4] &&!w) ||  // E -> D (w = 0)
           (y[5] && w);     // F -> C (w = 1) is not a case for Y1, but F -> D (w = 0) is

// Y3 is set when the next state is D
assign Y3 = (y[1] &&!w) ||  // B -> D (w = 0)
           (y[2] &&!w) ||  // C -> D (w = 0)
           (y[3] &&!w) ||  // D -> A (w = 0) is not a case for Y3, but D -> D (w = 0) is not in the FSM
           (y[4] &&!w) ||  // E -> D (w = 0)
           (y[5] &&!w);     // F -> D (w = 0)

endmodule