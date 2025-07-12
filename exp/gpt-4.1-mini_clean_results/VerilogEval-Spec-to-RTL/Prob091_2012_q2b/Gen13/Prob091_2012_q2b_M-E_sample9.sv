module TopModule (
    input  [5:0] y,  // one-hot encoded current state
    input        w,  // input bit
    output       Y1, // next state input for y[1] (state B)
    output       Y3  // next state input for y[3] (state D)
);

    // Y1: next state input for y[1] (B) active if current state is A (y[0]) and input w=1
    assign Y1 = y[0] & w;

    // Y3: next state input for y[3] (D) active if input w=0 and current state is B, C, E, or F
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule