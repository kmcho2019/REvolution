module TopModule(
    input  [5:0] y,  // one-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2, // next state bit for y[1] (state B)
    output       Y4  // next state bit for y[3] (state D)
);

    // From FSM:
    // Y2 (next B) = A(0) --0--> B => A_cur & ~w
    assign Y2 = y[0] & ~w;

    // Y4 (next D) comes from multiple transitions:
    // B(0)--1-->D: y[1] & w
    // C(0)--1-->D: y[2] & w
    // E(1)--1-->D: y[4] & w
    // F(1)--1-->D: y[5] & w
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule